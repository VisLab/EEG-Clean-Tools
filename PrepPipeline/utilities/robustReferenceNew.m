function referenceOut = robustReferenceNew(signal, referenceIn)
% Calculate the robust reference
referenceOut = referenceIn;
%% Check to make sure that reference channels have locations
chanlocs = referenceIn.channelLocations(referenceIn.referenceChannels);
if ~(length(cell2mat({chanlocs.X})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Y})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Z})) == length(chanlocs)) && ...
   ~(length(cell2mat({chanlocs.theta})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.radius})) == length(chanlocs))
   error('robustReference:NoChannelLocations', ...
         'reference channels must have locations');
end

%% Remove the huber mean and find the channels that are still noisy
[nanChannels, noSignalChannels] = ...
               findUnusableChannels(signal, referenceIn.referenceChannels); 
unusableChannels = union(nanChannels, noSignalChannels);
referenceChannels = setdiff(referenceIn.referenceChannels, unusableChannels);
signalTmp = removeHuberMean(signal, referenceChannels);

%% Now remove reference from the signal iteratively interpolate bad channels
noisyChannels = unusableChannels;
actualIterations = 0;                                
noisyChannelsOld = [];
while true
    noisyOut = findNoisyChannels(signalTmp, referenceIn);
    noisyChannels = union(noisyOut.noisyChannels, noisyChannels);
    if isempty(noisyChannels) || ...
            actualIterations > referenceIn.maxReferenceIterations || ...
            (isempty(setdiff(noisyChannels, noisyChannelsOld)) ...
            && isempty(setdiff(noisyChannelsOld, noisyChannels)))
        referenceSignal =  mean(signal.data(referenceChannels, :), 1);
        break;
    end  
    fprintf('Noisy old: %s\n', getListString(noisyChannelsOld));
    fprintf('Noisy new: %s\n', getListString(noisyChannels));
    noisyChannelsOld = noisyChannels; 
    sourceChannels = setdiff(referenceIn.referenceChannels, noisyChannels);
    if length(sourceChannels)  < 2
        error('robustReference:TooManyBad', ...
            'Could not perform a robust reference -- not enough good channels');
    end
    fprintf('Iteration: %d\n', actualIterations);
    fprintf('Interpolating channels: %s\n', getListString(noisyChannels));
    signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
    referenceSignal = mean(signalTmp.data(referenceChannels, :), 1);
    signalTmp = removeReference(signal, referenceSignal, referenceChannels);
    actualIterations = actualIterations + 1;
end
referenceOut.interpolatedChannels = noisyChannels;
referenceOut.referenceSignal = referenceSignal;
referenceOut.actualReferenceIterations = actualIterations;

