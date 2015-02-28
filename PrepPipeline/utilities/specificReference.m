function [signal, referenceOut] = specificReference(signal, referenceOut)
% References with respect to specific reference channels
%% Find the noisy channels for the initial starting point
referenceOut.noisyOutOriginal = findNoisyChannels(signal, referenceOut); 
unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
%% Now remove reference from the signal 
if ~isempty(referenceOut.referenceChannels)
   referenceOut.referenceSignalWithNoisyChannels = ...
      nanmean(signal.data(referenceOut.referenceChannels, :), 1);
else
   referenceOut.referenceSignalWithNoisyChannels = ...
      zeros(1, size(signal.data, 2));
end
signal = removeReference(signal, referenceOut.referenceSignalWithNoisyChannels, ...
                         referenceOut.rereferencedChannels);
                     
%% Interpolate the bad channels
paramsNew = referenceOut;
paramsNew.evaluationChannels = ...
    setdiff(referenceOut.evaluationChannels, unusableChannels);
noisyOut = findNoisyChannels(signal, paramsNew);

% Potential source channels are those that aren't noisy at all 
noisyChannels = union(noisyOut.noisyChannels, unusableChannels);
sourceChannels = setdiff(referenceOut.evaluationChannels, noisyChannels);
referenceOut.badChannels = noisyChannels;

if length(sourceChannels)  < 2
    error('specificReference:TooManyBad', ...
        'Could not perform interpolation -- not enough good channels');
elseif ~isempty(referenceOut.badChannels)  
    signal = interpolateChannels(signal, referenceOut.badChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, referenceOut); 
end
referenceOut.noisyOut = noisyOut;
referenceOut.badChannelsFromNaNs = noisyOut.badChannelsFromNaNs;
referenceOut.badChannelsFromNoData = noisyOut.badChannelsFromNoData;
referenceOut.badChannelsFromHFNoise = noisyOut.badChannelsFromHFNoise;
referenceOut.badChannelsFromCorrelation = noisyOut.badChannelsFromCorrelation;
referenceOut.badChannelsFromDeviation = noisyOut.badChannelsFromDeviation;
referenceOut.badChannelsFromRansac = noisyOut.badChannelsFromRansac;
referenceOut.badChannelsFromDropOuts = noisyOut.badChannelsFromDropOuts;
referenceOut.badChannels = noisyChannels;
noisyOut = findNoisyChannels(signal, referenceOut);
referenceOut.channelsStillBad = noisyOut.noisyChannels;
referenceOut.noisyOut = noisyOut;
