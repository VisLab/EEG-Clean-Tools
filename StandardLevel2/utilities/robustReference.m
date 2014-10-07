function [signal, reference] = robustReference(signal, reference)

if nargin < 1
    error('robustReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('robustReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('robustReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('robustReference:NoData', 'signal data must have multiple points');
elseif ~exist('reference', 'var') || isempty(reference)
    reference = struct();
elseif isempty(reference) || ~isstruct(reference)
    error('robustReference:NoData', 'second argument must be a structure')
end

reference =  getStructureParameters(reference, ...
    'referenceChannels',  1:size(signal.data, 1));
reference =  getStructureParameters(reference, ...
    'rereferencedChannels',  1:size(signal.data, 1));

%% Find the noisy channels for the initial starting point
reference.averageReferenceWithNoisyChannels = ...
                mean(signal.data(reference.referenceChannels, :), 1);

reference = findNoisyChannels(signal, reference); 
reference.noisyChannelOriginal = reference.noisyChannelResults;
%% Now remove the huber mean and find the channels that are still noisy
[signalTmp, reference.huberMean] = ...
                  removeHuberMean(signal, reference.referenceChannels);
reference = findNoisyChannels(signalTmp, reference); 

%% Construct new EEG with interpolated channels to find better average reference
signalTmp.data = signalTmp.data(reference.referenceChannels, :);
signalTmp.chanlocs = signalTmp.chanlocs(reference.referenceChannels);
signalTmp.nbchan = length(reference.referenceChannels);
noisyChannels = reference.noisyChannelResults.noisyChannels;
if ~isempty(noisyChannels)
    channelMask = false(1, size(signal.data, 1));
    channelMask(noisyChannels) = true;
    channelMask = channelMask(reference.referenceChannels);
    noisyChannelsReindexed = find(channelMask);
    signalTmp = interpolateChannels(signalTmp, noisyChannelsReindexed);
end
reference.averageReference = mean(double(signalTmp.data), 1);
clear signalTmp;

%% Now remove reference from filtered signal and interpolate bad channels
signal = removeReference(signal, reference.averageReference, ...
                         reference.rereferencedChannels);
reference = findNoisyChannels(signal, reference); 
reference.interpolatedChannels = reference.noisyChannelResults.noisyChannels;
if ~isempty(reference.interpolatedChannels)  
    sourceChannels = setdiff(reference.referenceChannels, reference.interpolatedChannels);
    signal = interpolateChannels(signal, reference.interpolatedChannels, sourceChannels);
end
reference = findNoisyChannels(signal, reference); 
