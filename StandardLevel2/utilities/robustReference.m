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
referenceOut.interpolateHFChannels = ...
    getStructureParameters(params, 'interpolateHFChannels', false);

%% Find the noisy channels for the initial starting point
referenceOut.averageReferenceWithNoisyChannels = ...
                mean(signal.data(referenceOut.referenceChannels, :), 1);

referenceOut.noisyOutOriginal = findNoisyChannels(signal, params); 

%% Now remove the huber mean and find the channels that are still noisy
[signalTmp, referenceOut.huberMean] = ...
                  removeHuberMean(signal, referenceOut.referenceChannels);
noisyOutHuber = findNoisyChannels(signalTmp, params); 

%% Construct new EEG with interpolated channels to find better average reference
signalTmp.data = signalTmp.data(referenceOut.referenceChannels, :);

%%
fprintf('Reference channels in robust reference:\n');
printList(1, referenceOut.referenceChannels, 10, '   ');
fprintf('Channels %g\n', length(signalTmp.chanlocs)); 
signalTmp.chanlocs = signalTmp.chanlocs(referenceOut.referenceChannels);
signalTmp.nbchan = length(referenceOut.referenceChannels);
noisyChannels = noisyOutHuber.noisyChannels;
if length(signalTmp.chanlocs) - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels)
    channelMask = false(1, size(signal.data, 1));
    channelMask(noisyChannels) = true;
    channelMask = channelMask(referenceOut.referenceChannels);
    noisyChannelsReindexed = find(channelMask);
    signalTmp = interpolateChannels(signalTmp, noisyChannelsReindexed);
end
referenceOut.averageReference = mean(double(signalTmp.data), 1);
clear signalTmp;

%% Now remove reference from filtered signal and interpolate bad channels
signal = removeReference(signal, referenceOut.averageReference, ...
                         referenceOut.rereferencedChannels);
noisyOut = findNoisyChannels(signal, params);
% Potential source channels are those that aren't noisy at all 
sourceChannels = setdiff(referenceOut.referenceChannels, noisyOut.noisyChannels);

% Interpolated channels may not be interpolated if only fail because of HF
referenceOut.interpolatedChannels = noisyOut.noisyChannels;
referenceOut.badChannelsNotInterpolated = [];
if ~referenceOut.interpolateHFChannels % Don't interpolate HF channels
    referenceOut.interpolatedChannels = union(...
           noisyOut.badChannelsFromDeviation, union( ...
           noisyOut.badChannelsFromCorrelation, ...
           noisyOut.badChannelsFromRansac));
    referenceOut.badChannelsNotInterpolated = setdiff( ...
        noisyOut.badChannelsFromHFNoise, referenceOut.interpolatedChannels);
end
sourceChannels = setdiff(sourceChannels, referenceOut.interpolatedChannels);
if length(sourceChannels)  < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(referenceOut.interpolatedChannels)  
    signal = interpolateChannels(signal, referenceOut.interpolatedChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, params); 
end
referenceOut.noisyOut = noisyOut;
