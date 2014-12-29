function [signal, referenceOut] = robustReference(signal, params)

if nargin < 1
    error('robustReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('robustReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('robustReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('robustReference:NoData', 'signal data must have multiple points');
elseif ~exist('params', 'var') || isempty(params)
    params = struct();
end
if ~isstruct(params)
    error('robustReference:NoData', 'second argument must be a structure')
end
referenceOut = struct();
 
referenceOut.referenceChannels = getStructureParameters(params, ...
    'referenceChannels',  1:size(signal.data, 1));
referenceOut.rereferencedChannels =  getStructureParameters(params, ...
    'rereferencedChannels',  1:size(signal.data, 1));
referenceOut.channelLocations = getStructureParameters(params, ...
    'channelLocations', signal.chanlocs);
referenceOut.channelInformation = getStructureParameters(params, ...
    'channelInformation', signal.chaninfo);
% referenceOut.interpolateHFChannels = ...
%     getStructureParameters(params, 'interpolateHFChannels', false);
referenceOut.maxInterpolationIterations = ...
     getStructureParameters(params, 'maxInterpolationIterations', 2);
referenceOut.actualInterpolationIterations = 0;
%% Check to make sure that reference channels have locations
chanlocs = referenceOut.channelLocations(referenceOut.referenceChannels);
if ~(length(cell2mat({chanlocs.X})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Y})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Z})) == length(chanlocs)) && ...
   ~(length(cell2mat({chanlocs.theta})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.radius})) == length(chanlocs))
   error('robustReference:NoChannelLocations', ...
         'reference channels must have locations');
end

%% Find the noisy channels for the initial starting point
referenceOut.averageReferenceWithNoisyChannels = ...
                mean(signal.data(referenceOut.referenceChannels, :), 1);

referenceOut.noisyOutOriginal = findNoisyChannels(signal, params); 

%% Now remove the huber mean and find the channels that are still noisy
unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
referenceChannels = setdiff(referenceOut.referenceChannels, unusableChannels);
[signalTmp, referenceOut.huberMean] = ...
                  removeHuberMean(signal, referenceChannels);
noisyOutHuber = findNoisyChannels(signalTmp, params); 

%% Construct new EEG with interpolated channels to find better average reference
signalTmp = signal;
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels)  
    signalTmp = interpolateChannels(signalTmp, noisyChannels, sourceChannels);
end
averageReference = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
clear signalTmp;

%% Now remove reference from the signal and interpolate bad channels
signal = removeReference(signal, averageReference, ...
                         referenceOut.rereferencedChannels);

% Potential source channels are those that aren't noisy at all 
paramsNew = params;
paramsNew.referenceChannels = setdiff(params.referenceChannels, ...
                                      unusableChannels);
% Interpolate channels
badChannelsFromNaNs = [];
badChannelsFromNoData = [];
badChannelsFromHFNoise = [];
badChannelsFromCorrelation = [];
badChannelsFromDeviation = [];
badChannelsFromRansac = [];
badChannelsFromDropOuts = [];
interpolatedChannels = unusableChannels;
actualIterations = 0;
for k = 1:referenceOut.maxInterpolationIterations
    if length(sourceChannels)  < 2
        error('ordinaryReference:TooManyBad', ...
            'Could not perform a robust reference -- not enough good channels');
    end
    noisyOut = findNoisyChannels(signal, paramsNew);
    badChannelsFromNaNs = ...
        union(noisyOut.badChannelsFromNaNs, badChannelsFromNaNs);
    badChannelsFromNoData = ...
        union(noisyOut.badChannelsFromNoData, badChannelsFromNoData);
    badChannelsFromHFNoise = ...
        union(noisyOut.badChannelsFromHFNoise, badChannelsFromHFNoise);
    badChannelsFromCorrelation = ...
        union(noisyOut.badChannelsFromCorrelation, badChannelsFromCorrelation);
    badChannelsFromDeviation = ...
        union(noisyOut.badChannelsFromDeviation, badChannelsFromDeviation);
    badChannelsFromRansac = ...
        union(noisyOut.badChannelsFromRansac, badChannelsFromRansac);
    badChannelsFromDropOuts = ...
        union(noisyOut.badChannelsFromDropOuts, badChannelsFromDropOuts);
    noisyChannels = noisyOut.noisyChannels;
    if isempty(noisyChannels)
        break;
    end
    actualIterations = actualIterations + 1;
    interpolatedChannels = union(noisyChannels, interpolatedChannels);
    sourceChannels = setdiff(referenceOut.referenceChannels, interpolatedChannels);
    signal = interpolateChannels(signal, interpolatedChannels, sourceChannels);
    averageReferenceNew = mean(signal.data(referenceOut.referenceChannels, :), 1);
    signal = removeReference(signal, averageReferenceNew, ...
        referenceOut.rereferencedChannels);
    averageReference = averageReference + averageReferenceNew;
end
referenceOut.noisyOut = findNoisyChannels(signal, params);
referenceOut.badChannelsFromNaNs = union(badChannelsFromNaNs(:)', ...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs(:)');
referenceOut.badChannelsFromNoData = union(badChannelsFromNoData(:)', ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData(:)');
referenceOut.badChannelsFromHFNoise = badChannelsFromHFNoise(:)';
referenceOut.badChannelsFromCorrelation = badChannelsFromCorrelation(:)';
referenceOut.badChannelsFromDeviation = badChannelsFromDeviation(:)';
referenceOut.badChannelsFromRansac = badChannelsFromRansac(:)';
referenceOut.badChannelsFromDropOuts = badChannelsFromDropOuts(:)';
referenceOut.interpolatedChannels = interpolatedChannels(:)';
referenceOut.badChannelsNotInterpolated = [];
referenceOut.averageReference = averageReference;
referenceOut.actualInterpolationIterations = actualIterations;

