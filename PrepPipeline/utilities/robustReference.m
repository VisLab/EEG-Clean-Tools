function referenceOut = robustReference(signal, referenceIn)
% Find the channels that are to be interpolated for a robust reference
referenceOut = referenceIn;

%% Remove the huber mean and find the channels that are still noisy
[badChannelsFromNaNs, badChannelsFromNoData] = ...
               findUnusableChannels(signal, referenceIn.referenceChannels); 
unusableChannels = union(badChannelsFromNaNs, badChannelsFromNoData);
referenceOut.interpolatedChannels.badChannelsFromNaNs = badChannelsFromNaNs;
referenceOut.interpolatedChannels.badChannelsFromNoData = badChannelsFromNoData;
referenceChannels = setdiff(referenceIn.referenceChannels, unusableChannels);
signalTmp = removeHuberMean(signal, referenceChannels);

%% Now remove reference from the signal iteratively interpolate bad channels
referenceOut.actualReferenceIterations = 0;                                
noisyChannelsOld = [];
while true
    noisyOut = findNoisyChannels(signalTmp, referenceIn);
    referenceOut.interpolatedChannels = ...
        updateBadChannels(referenceOut.interpolatedChannels, ...
        noisyOut.noisyChannels);
    noisyChannels = referenceOut.interpolatedChannels.all;
    if isempty(noisyChannels) || ...
       referenceOut.actualReferenceIterations > ...
       referenceIn.maxReferenceIterations || ...
       (isempty(setdiff(noisyChannels, noisyChannelsOld)) ...
        && isempty(setdiff(noisyChannelsOld, noisyChannels)))
        break;
    end  
    noisyChannelsOld = noisyChannels; 
    sourceChannels = setdiff(referenceIn.referenceChannels, noisyChannels);
    if length(sourceChannels)  < 2
        error('robustReference:TooManyBad', ...
            'Could not perform a robust reference -- not enough good channels');
    end
    fprintf('Iteration: %d\n', referenceOut.actualReferenceIterations);
    fprintf('Interpolating channels: %s\n', getListString(noisyChannels));
    signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
    referenceSignal = mean(signalTmp.data(referenceChannels, :), 1);
    signalTmp = removeReference(signal, referenceSignal, referenceChannels);
    referenceOut.actualReferenceIterations = ...
        referenceOut.actualReferenceIterations + 1;
end
