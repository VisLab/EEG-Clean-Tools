function [signal, referenceOut] = robustReference(signal, referenceIn)

if nargin < 1
    error('robustReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('robustReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('robustReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('robustReference:NoData', 'signal data must have multiple points');
elseif ~exist('referenceIn', 'var') || isempty(referenceIn)
    referenceIn = struct();
end
if ~isstruct(referenceIn)
    error('robustReference:NoData', 'second argument must be a structure')
end
referenceOut = struct();
 
referenceOut.referenceChannels = getStructureParameters(referenceIn, ...
    'referenceChannels',  1:size(signal.data, 1));
referenceOut.rereferencedChannels =  getStructureParameters(referenceIn, ...
    'rereferencedChannels',  1:size(signal.data, 1));
referenceOut.channelLocations = getStructureParameters(referenceIn, ...
                                     'channelLocations', signal.chanlocs);
referenceOut.channelInformation = getStructureParameters(referenceIn, ...
                                     'channelInformation', signal.chaninfo);
%% Find the noisy channels for the initial starting point
referenceOut.averageReferenceWithNoisyChannels = ...
                mean(signal.data(referenceOut.referenceChannels, :), 1);

referenceOut.noisyOutOriginal = findNoisyChannels(signal, referenceOut); 

%% Now remove the huber mean and find the channels that are still noisy
[signalTmp, referenceOut.huberMean] = ...
                  removeHuberMean(signal, referenceOut.referenceChannels);
noisyOutHuber = findNoisyChannels(signalTmp, referenceOut); 

%% Construct new EEG with interpolated channels to find better average reference
signalTmp.data = signalTmp.data(referenceOut.referenceChannels, :);
signalTmp.chanlocs = signalTmp.chanlocs(referenceOut.referenceChannels);
signalTmp.nbchan = length(referenceOut.referenceChannels);
noisyChannels = noisyOutHuber.noisyChannels;
if ~isempty(noisyChannels)
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
noisyOut = findNoisyChannels(signal, referenceIn); 
referenceOut.interpolatedChannels = noisyOut.noisyChannels;
if ~isempty(referenceOut.interpolatedChannels)  
    sourceChannels = setdiff(referenceOut.referenceChannels, referenceOut.interpolatedChannels);
    signal = interpolateChannels(signal, referenceOut.interpolatedChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, referenceOut); 
end
referenceOut.noisyOut = noisyOut;
