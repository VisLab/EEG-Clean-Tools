function  noisyOut = findNoisyChannels(signal, params)
% Identify bad channels in EEG using a two-stage approach
%
% reference = findNoisyChannels(signal)
% reference = findNoisyChannels(signal, reference)
%
% First remove bad channels by amplitude, noise level, and correlation
% Apply ransac after these channels have been removed.
%
% Input parameters:
%     signal - structure with srate, chanlocs, chaninfo, and data fields
%     params - structure with input parameters 
%
%  Notes: the signal is assumed to be high-passed. Removing line noise
%  is a good idea too.
%
%  params: (fields are filled in on input if not present and propagated to output)
%     name - name of the input file
%     srate - sample rate in HZ
%     samples - number of samples in the data
%     referenceChannels - a vector of channels to use
%     chaninfo - standard EEGLAB chaninfo (nose direction is relevant)
%     chanlocs - standard EEGLAB chanlocs structure
%     robustDeviationThreshold - z score cutoff of robust channel deviation
%     highFrequencyNoiseThreshold -  z score cutoff of SNR (signal above 50 Hz)
%     correlationWindowSeconds - correlation window size in seconds (default = 1 sec)
%     correlationThreshold - correlation below which window is bad (default = 0.4)
%     badTimeThreshold - cutoff fraction of bad corr windows (default = 0.01)
%     ransacSampleSize - samples for computing ransac (default = 50)
%     ransacChannelFraction - fraction of channels for robust reconstruction (default = 0.25)
%     ransacCorrelationThreshold - cutoff correlation for abnormal wrt neighbors(default = 0.75)
%     ransacUnbrokenTime - cutoff fraction of time channel can be bad (default = 0.4)
%     ransacWindowSeconds - correlation window for ransac (default = 5 sec)
%
% Output parameters (c channels, w windows):
%    ransacPerformed - true if there were enough good channels to do ransac
%    noisyChannels - list of identified bad channel numbers
%    badChannelsFromCorrelation  - list of bad channels identified by correlation
%    badChannelsFromDeviation   - list of bad channels identified by amplitude
%    badChannelsFromHFNoise - list of bad channels identified by SNR
%    badChannelsFromRansac - list of channels identified by ransac
%    fractionBadCorrelationWindows - c x 1 vector with fraction of bad correlation windows
%    robustChannelDeviation - c x 1 vector with robust measure of average channel deviation
%    zscoreHFNoise - c x 1 vector with measure of channel noise level
%    maximumCorrelations - w x c array with max window correlation
%    ransacCorrelations = c x wr array with ransac correlations
%
% This function uses 4 methods for detecting bad channels after removing
% from consideration channels that have NaN data or channels that are
% identically constant.
%
% Method 1: too low or high amplitude. If the z score of robust
%           channel deviation falls below robustDeviationThreshold, the channel is
%           considered to be bad.
% Method 2: too low an SNR. If the z score of estimate of signal above
%           50 Hz to that below 50 Hz above highFrequencyNoiseThreshold, the channel
%           is considered to be bad.
%
% Method 3: low correlation with other channels. Here correlationWindowSize is the window
%           size over which the correlation is computed. If the maximum
%           correlation of the channel to the other channels falls below
%           correlationThreshold, the channel is considered bad in that window.
%           If the fraction of bad correlation windows for a channel
%           exceeds badTimeThreshold, the channel is marked as bad.
%
% After the channels from methods 2 and 3 are removed, method 4 is
% computed on the remaining signals
%
% Method 4: each channel is predicted using ransac interpolation based
%           on a ransac fraction of the channels. If the correlation of
%           the prediction to the actual behavior is too low for too
%           long, the channel is marked as bad.
%
% Assumptions:
%  - The signal is a structure of continuous data with data, srate, chanlocs,
%    and chaninfo fields.
%  - The signal.data has been high pass filtered.
%  - No segments of the EEG data have been removed

% Methods 1 and 4 are adapted from code by Christian Kothe and Methods 2
% and 3 are adapted from code by Nima Bigdely-Shamlo
%
%% Check the incoming parameters
if nargin < 1
    error('findNoisyChannels:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('findNoisyChannels:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('findNoisyChannels:DataNotContinuous', 'data must be a 2D array');
elseif nargin < 2 || ~exist('params', 'var') || isempty(params)
    params = struct();
end

noisyOut = struct('srate', [], ...
                      'samples', [], ...
                      'referenceChannels', [], ...
                      'robustDeviationThreshold', [], ...
                      'highFrequencyNoiseThreshold', [], ...
                      'correlationWindowSeconds', [], ...
                      'correlationThreshold', [], ...
                      'badTimeThreshold', [], ...
                      'ransacSampleSize', [], ...
                      'ransacChannelFraction', [], ...
                      'ransacCorrelationThreshold', [], ...
                      'ransacUnbrokenTime', [], ...
                      'ransacWindowSeconds', [], ...
                      'noisyChannels', [], ...
                      'badChannelsFromNaNs', [], ... 
                      'badChannelsFromNoData', [], ... 
                      'badChannelsFromHFNoise', [],  ...
                      'badChannelsFromCorrelation', [], ...
                      'badChannelsFromDeviation', [], ...
                      'badChannelsFromRansac', [], ... 
                      'badChannelsFromDropOuts', [], ...
                      'ransacPerformed', true, ...
                      'channelDeviationMedian', [], ...
                      'channelDeviationSD', [], ...
                      'channelDeviations', [], ...
                      'robustChannelDeviation', [], ...
                      'noisinessMedian', [], ...
                      'noisinessSD', [], ...
                      'zscoreHFNoise', [], ...
                      'noiseLevels', [], ...
                      'maximumCorrelations', [], ...
                      'dropOuts', [], ...
                      'medianMaxCorrelation', [], ...
                      'correlationOffsets', [], ...
                      'ransacCorrelations', [], ...
                      'ransacOffsets', [], ...
                      'ransacBadWindowFraction', []);
%% Set the defaults as needed
noisyOut.srate = getStructureParameters(params, 'srate', signal.srate);
noisyOut.samples = getStructureParameters(params, 'samples', size(signal.data, 2));
noisyOut.referenceChannels = getStructureParameters(params, 'referenceChannels', 1:size(signal.data, 1));
channelLocations = getStructureParameters(params, 'channelLocations', signal.chanlocs);
noisyOut.robustDeviationThreshold = getStructureParameters(params, 'robustDeviationThreshold', 5);
noisyOut.highFrequencyNoiseThreshold = getStructureParameters(params, 'highFrequencyNoiseThreshold', 5);
noisyOut.correlationWindowSeconds = getStructureParameters(params, 'correlationWindowSeconds', 1);
noisyOut.correlationThreshold = getStructureParameters(params, 'correlationThreshold', 0.4);
noisyOut.badTimeThreshold = getStructureParameters(params, 'badTimeThreshold', 0.01);
noisyOut.ransacSampleSize = getStructureParameters(params, 'ransacSampleSize', 50);
noisyOut.ransacChannelFraction = getStructureParameters(params, 'ransacChannelFraction', 0.25);
noisyOut.ransacCorrelationThreshold = getStructureParameters(params, 'ransacCorrelationThreshold', 0.75);
noisyOut.ransacUnbrokenTime = getStructureParameters(params, 'ransacUnbrokenTime', 0.4);
noisyOut.ransacWindowSeconds = getStructureParameters(params, 'ransacWindowSeconds', 5);

%% Set the computed fields to be empty
referenceChannels = sort(noisyOut.referenceChannels); % Make sure channels are sorted
referenceChannels = referenceChannels(:)';            % Make sure row vector
noisyOut.referenceChannels = referenceChannels;  

%% Now detect reference channels that are constant for large periods or have NaNs
nanChannels = sum(isnan(signal.data(referenceChannels, :)), 2) > 0;
noSignalChannels = mad(signal.data(referenceChannels, :), 1, 2) < 10e-10 | ...
    std(signal.data(referenceChannels, :), 1, 2) < 10e-10;
noisyOut.badChannelsFromNaNs = referenceChannels(nanChannels(:)');
noisyOut.badChannelsFromNoData = referenceChannels(noSignalChannels(:)');
referenceChannels = setdiff(referenceChannels, ...
    union(noisyOut.badChannelsFromNaNs, noisyOut.badChannelsFromNoData));

%% Extact the data required
data = signal.data;
originalNumberChannels = size(data, 1);          % Save the original channels
data = double(data(referenceChannels, :))';      % Remove the unneeded channels
[signalSize, numberChannels] = size(data);
correlationFrames = noisyOut.correlationWindowSeconds * signal.srate;
correlationWindow = 0:(correlationFrames - 1);
correlationOffsets = 1:correlationFrames:(signalSize-correlationFrames);
WCorrelation = length(correlationOffsets);
ransacFrames = noisyOut.ransacWindowSeconds*noisyOut.srate;
ransacWindow = 0:(ransacFrames - 1);
ransacOffsets = 1:ransacFrames:(signalSize-ransacFrames);
WRansac = length(ransacOffsets);
noisyOut.zscoreHFNoise = zeros(originalNumberChannels, 1);
noisyOut.noiseLevels = zeros(originalNumberChannels, WCorrelation);
noisyOut.maximumCorrelations = ones(originalNumberChannels, WCorrelation);
noisyOut.dropOuts = zeros(originalNumberChannels, WCorrelation);
noisyOut.correlationOffsets = correlationOffsets;
noisyOut.channelDeviations = zeros(originalNumberChannels, WCorrelation);
noisyOut.robustChannelDeviation = zeros(originalNumberChannels, 1);
noisyOut.ransacCorrelations = ones(originalNumberChannels, WRansac);
noisyOut.ransacOffsets = ransacOffsets;

%% Method 1: Unusually high or low amplitude (using robust std)
channelDeviation = 0.7413 *iqr(data); % Robust estimate of SD
channelDeviationSD =  0.7413 * iqr(channelDeviation);
channelDeviationMedian = nanmedian(channelDeviation);
noisyOut.robustChannelDeviation(referenceChannels) = ...
    (channelDeviation - channelDeviationMedian) / channelDeviationSD;

% Find channels with unusually high deviation 
badChannelsFromDeviation = ...
    find(abs(noisyOut.robustChannelDeviation) > ...
             noisyOut.robustDeviationThreshold | ...
             isnan(noisyOut.robustChannelDeviation));
noisyOut.badChannelsFromDeviation = badChannelsFromDeviation(:)';
noisyOut.channelDeviationMedian = channelDeviationMedian;
noisyOut.channelDeviationSD = channelDeviationSD;

%% Method 2: Compute the SNR (based on Christian Kothe's clean_channels)
% Note: RANSAC uses the filtered values X of the data
if noisyOut.srate > 100
    % Remove signal content above 50Hz
    B = design_fir(100,[2*[0 45 50]/noisyOut.srate 1],[1 1 0 0]);
    X = zeros(signalSize, numberChannels);
    for k = 1:numberChannels  % Could be changed to parfor
        X(:,k) = filtfilt_fast(B, 1, data(:, k)); end
    % Determine z-scored level of EM noise-to-signal ratio for each channel
    noisiness = mad(data- X, 1)./mad(X, 1);
    noisinessMedian = nanmedian(noisiness);
    noisinessSD = mad(noisiness, 1)*1.4826;
    zscoreHFNoiseTemp = (noisiness - noisinessMedian) ./ noisinessSD;
    noiseMask = (zscoreHFNoiseTemp > noisyOut.highFrequencyNoiseThreshold) | ...
                isnan(zscoreHFNoiseTemp);
    % Remap channels to original numbering
    badChannelsFromHFNoise  = referenceChannels(noiseMask);
    noisyOut.badChannelsFromHFNoise = badChannelsFromHFNoise(:)';
else
    X = data;
    noisinessMedian = 0;
    noisinessSD = 1;
    zscoreHFNoiseTemp = zeros(numberChannels, 1);
    noisyOut.badChannelsFromHFNoise = [];
end

% Remap the channels to original numbering for the zscoreHFNoise
noisyOut.zscoreHFNoise(referenceChannels) = zscoreHFNoiseTemp;
noisyOut.noisinessMedian = noisinessMedian;
noisyOut.noisinessSD = noisinessSD;
%% Method 3: Global correlation criteria (from Nima Bigdely-Shamlo)
channelCorrelations = ones(WCorrelation, numberChannels);
noiseLevels = zeros(WCorrelation, numberChannels);
channelDeviations = zeros(WCorrelation, numberChannels);
n = length(correlationWindow);
xWin = reshape(X(1:n*WCorrelation, :)', numberChannels, n, WCorrelation);
dataWin = reshape(data(1:n*WCorrelation, :)', numberChannels, n, WCorrelation);
parfor k = 1:WCorrelation 
    eegPortion = squeeze(xWin(:, :, k))';
    dataPortion = squeeze(dataWin(:, :, k))';
    windowCorrelation = corrcoef(eegPortion);
    abs_corr = abs(windowCorrelation - diag(diag(windowCorrelation)));
    channelCorrelations(k, :)  = quantile(abs_corr, 0.98);
    noiseLevels(k, :) = mad(dataPortion - eegPortion, 1)./mad(eegPortion, 1);
    channelDeviations(k, :) =  0.7413 *iqr(dataPortion);
end;
dropOuts = isnan(channelCorrelations) | isnan(noiseLevels);
channelCorrelations(dropOuts) = 0.0;
noiseLevels(dropOuts) = 0.0;
clear xWin;
clear dataWin;
noisyOut.maximumCorrelations(referenceChannels, :) = channelCorrelations';
noisyOut.noiseLevels(referenceChannels, :) = noiseLevels';
noisyOut.channelDeviations(referenceChannels, :) = channelDeviations';
noisyOut.dropOuts(referenceChannels, :) = dropOuts';
thresholdedCorrelations = ...
    noisyOut.maximumCorrelations < noisyOut.correlationThreshold;
fractionBadCorrelationWindows = mean(thresholdedCorrelations, 2);
fractionBadDropOutWindows = mean(noisyOut.dropOuts, 2);

% Remap channels to their original numbers
badChannelsFromCorrelation = ...
    find(fractionBadCorrelationWindows > noisyOut.badTimeThreshold);
badChannelsFromDropOuts = ...
    find(fractionBadDropOutWindows > noisyOut.badTimeThreshold);
noisyOut.badChannelsFromCorrelation = badChannelsFromCorrelation(:)';
noisyOut.badChannelsFromDropOuts = badChannelsFromDropOuts(:)';
noisyOut.medianMaxCorrelation =  median(noisyOut.maximumCorrelations, 2);

%% Bad so far by amplitude and correlation (take these out before doing ransac)
noisyChannels = union(noisyOut.badChannelsFromDeviation, ...
    union(noisyOut.badChannelsFromCorrelation, ...
          noisyOut.badChannelsFromDropOuts));
%% Method 4: Ransac corelation (may not be performed)
% Setup for ransac (if a 2-stage algorithm, remove other bad channels first)
if isempty(channelLocations) 
    warning('findNoisyChannels:noChannelLocation', ...
        'ransac could not be computed because there were no channel locations');
    noisyOut.badChannelsFromRansac = [];
    noisyOut.ransacBadWindowFraction = 0;
    noisyOut.ransacPerformed = false;
else % Set up parameters and make sure enough good channels to proceed
    [ransacChannels, idiff] = setdiff(referenceChannels, noisyChannels);
    X = X(:, idiff);

    % Calculate the parameters for ransac
    ransacSubset = round(noisyOut.ransacChannelFraction*size(data, 2));
    if noisyOut.ransacUnbrokenTime < 0
        error('find_noisyChannels:BadUnbrokenParameter', ...
            'ransacUnbrokenTime must be greater than 0');
    elseif noisyOut.ransacUnbrokenTime < 1
        ransacUnbrokenFrames = signalSize*noisyOut.ransacUnbrokenTime;
    else
        ransacUnbrokenFrames = srate*noisyOut.ransacUnbrokenTime;
    end

    nchanlocs = channelLocations(ransacChannels);
    if length(nchanlocs) ~= size(nchanlocs, 2)
        nchanlocs = nchanlocs';
    end
    if length(nchanlocs) < ransacSubset + 1 || length(nchanlocs) < 3 || ...
            ransacSubset < 2
        warning('find_noisyChannels:NotEnoughGoodChannels', ...
            'Too many channels have failed quality tests to perform ransac');
        noisyOut.badChannelsFromRansac = [];
        noisyOut.ransacBadWindowFraction = 0;
        noisyOut.ransacPerformed = false;
    end
end
if noisyOut.ransacPerformed 
    try 
    % Calculate all-channel reconstruction matrices from random channel subsets
       locs = [cell2mat({nchanlocs.X}); cell2mat({nchanlocs.Y});cell2mat({nchanlocs.Z})];
    catch err
       error('findNoisyChannels:NoXYZChannelLocations', ...
             'Must provide valid channel locations');
    end         
    if isempty(locs) || size(locs, 2) ~= length(ransacChannels) ...
            || any(isnan(locs(:))) 
          error('find_noisyChannels:EmptyChannelLocations', ...
            'The signal chanlocs must have valid X, Y, and Z components');      
    end
    P = hlp_microcache('cleanchans', @calc_projector, locs, ...
        noisyOut.ransacSampleSize, ransacSubset);
    ransacCorrelationsT = zeros(length(locs), WRansac);

    % Calculate each channel's correlation to its RANSAC reconstruction for each window
    n = length(ransacWindow);
    m = length(ransacChannels);
    p = noisyOut.ransacSampleSize;
    Xwin = reshape(X(1:n*WRansac, :)', m, n, WRansac);
    parfor k = 1:WRansac
        ransacCorrelationsT(:, k) = ...
            calculateRansacWindow(squeeze(Xwin(:, :, k))', P, n, m, p);
    end
    clear Xwin;
    noisyOut.ransacCorrelations(ransacChannels, :) = ransacCorrelationsT;
    flagged = noisyOut.ransacCorrelations < noisyOut.ransacCorrelationThreshold;
    badChannelsFromRansac = ...
        find(sum(flagged, 2)*ransacFrames > ransacUnbrokenFrames)';
    noisyOut.badChannelsFromRansac = badChannelsFromRansac(:)';
    noisyOut.ransacBadWindowFraction = sum(flagged, 2)/size(flagged, 2);
end

% Combine bad channels detected from all methods
noisyChannels = union(noisyChannels, ...
    union(union(noisyOut.badChannelsFromRansac, ...
          noisyOut.badChannelsFromHFNoise), ...
    union(noisyOut.badChannelsFromNaNs, ...
          noisyOut.badChannelsFromNoData)));
noisyOut.noisyChannels = noisyChannels;
noisyOut.medianMaxCorrelation =  median(noisyOut.maximumCorrelations, 2);

%% Helper functions for findNoisyChannels
function P = calc_projector(locs, numberSamples, subsetSize)
% Calculate a bag of reconstruction matrices from random channel subsets

[permutedLocations, subsets] = getRandomSubsets(locs, subsetSize, numberSamples);
randomSamples = cell(1, numberSamples);
parfor k = 1:numberSamples
    tmp = zeros(size(locs, 2));
    slice = subsets(k, :);
    tmp(slice, :) = real(spherical_interpolate(permutedLocations(:, :, k), locs))';
    randomSamples{k} = tmp;
end
P = horzcat(randomSamples{:});

function [permutedLocations, subsets] = getRandomSubsets(locs, subsetSize, numberSamples)
 stream = RandStream('mt19937ar', 'Seed', 435656);
 numberChannels = size(locs, 2);
 permutedLocations = zeros(3, subsetSize, numberSamples);
 subsets = zeros(numberSamples, subsetSize);
 for k = 1:numberSamples
     subset = randsample(1:numberChannels, subsetSize, stream);
     subsets(k, :) = subset;
     permutedLocations(:, :,  k) = locs(:, subset);
 end

function Y = randsample(X, num, stream)
Y = zeros(1, num);
for k = 1:num
    pick = round(1 + (length(X)-1).*rand(stream));
    Y(k) = X(pick);
    X(pick) = [];
end

function rX = calculateRansacWindow(XX, P, n, m, p)
    YY = sort(reshape(XX*P, n, m, p),3);
    YY = YY(:, :, round(end/2));
    rX = sum(XX.*YY)./(sqrt(sum(XX.^2)).*sqrt(sum(YY.^2)));



