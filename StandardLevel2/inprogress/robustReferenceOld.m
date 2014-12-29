function [signal, referenceOut] = robustReferenceOld(signal, params)

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
referenceOut.interpolateHFChannels = ...
    getStructureParameters(params, 'interpolateHFChannels', false);
referenceOut.iterateInterpolation = ...
    getStructureParameters(params, 'iterateInterpolation', true);
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
% signalTmp.data = signal.data(referenceOut.referenceChannels, :);
% signalTmp.chanlocs = signal.chanlocs(referenceOut.referenceChannels);
% signalTmp.nbchan = length(referenceOut.referenceChannels);
signalTmp = signal;
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels)
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    signalTmp = interpolateChannels(signalTmp, noisyChannels, sourceChannels);
end
referenceOut.averageReference = ...
    mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
clear signalTmp;

%% Now remove reference from the signal and interpolate bad channels
signal = removeReference(signal, referenceOut.averageReference, ...
                         referenceOut.rereferencedChannels);

% Potential source channels are those that aren't noisy at all 
paramsNew = params;
paramsNew.referenceChannels = setdiff(params.referenceChannels, ...
                                      unusableChannels);
noisyOut = findNoisyChannels(signal, paramsNew);
noisyChannels = union(noisyOut.noisyChannels, unusableChannels);
sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);

% Interpolated channels may not be interpolated if failed because of HF
if referenceOut.interpolateHFChannels
    referenceOut.interpolatedChannels = noisyChannels;
    referenceOut.badChannelsNotInterpolated = [];
else % Don't interpolate HF channels
    referenceOut.interpolatedChannels = union(unusableChannels, union( ...
           noisyOut.badChannelsFromDeviation, union( ...
           noisyOut.badChannelsFromCorrelation, ...
           noisyOut.badChannelsFromRansac)));
    referenceOut.badChannelsNotInterpolated = setdiff( ...
        noisyOut.badChannelsFromHFNoise, referenceOut.interpolatedChannels);
end

if length(sourceChannels)  < 2
    error('ordinaryReference:TooManyBad', ...
        'Could not perform a robust reference -- not enough good channels');
elseif ~isempty(referenceOut.interpolatedChannels)  
    signal = interpolateChannels(signal, referenceOut.interpolatedChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, params); 
end
referenceOut.noisyOut = noisyOut;
