function [signal, referenceOut] = robustReference(signal, referenceIn)
% Calculate the robust reference
referenceOut = referenceIn;
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
referenceOut.referenceSignalWithNoisyChannels = ...
                nanmean(signal.data(referenceOut.referenceChannels, :), 1);
referenceIn.evaluationChannels = referenceOut.referenceChannels;
referenceOut.noisyOutOriginal = findNoisyChannels(signal, referenceIn); 

%% Now remove the huber mean and find the channels that are still noisy
unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
referenceChannels = setdiff(referenceOut.referenceChannels, unusableChannels);
signalTmp = removeHuberMean(signal, referenceChannels);
noisyOutHuber = findNoisyChannels(signalTmp, referenceIn); 

%% Construct new EEG with interpolated channels to find better average reference
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels) 
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
else
    signalTmp = signal;
end
averageReference = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
signalTmp = removeReference(signal, averageReference, ...
                                 referenceOut.rereferencedChannels);
%% Now remove reference from the signal iteratively interpolate bad channels
noisyChannels = unusableChannels;
badChannelsFromNaNs = [];
badChannelsFromNoData = [];
badChannelsFromHFNoise = [];
badChannelsFromCorrelation = [];
badChannelsFromDeviation = [];
badChannelsFromRansac = [];
badChannelsFromDropOuts = [];
actualIterations = 0;
paramsNew = referenceIn;
paramsNew.referenceChannels = setdiff(referenceIn.referenceChannels, ...
                                      unusableChannels);
noisyChannelsOld = [];
while true  
    noisyOut = findNoisyChannels(signalTmp, paramsNew);
    if isempty(noisyOut.noisyChannels) || ...
            actualIterations > referenceOut.maxReferenceIterations || ...
            (isempty(setdiff(noisyOut.noisyChannels, noisyChannelsOld)) ...
            && isempty(setdiff(noisyChannelsOld, noisyOut.noisyChannels)))
        break;
    end
    noisyChannelsOld = noisyOut.noisyChannels;
    noisyChannels = union(noisyOut.noisyChannels, noisyChannels);
    sourceChannels = setdiff(referenceIn.referenceChannels, noisyChannels);
    badChannelsFromNaNs = union(badChannelsFromNaNs, ...
          noisyOut.badChannelsFromNaNs);
    badChannelsFromNoData = union(badChannelsFromNoData, ...
          noisyOut.badChannelsFromNoData);
      badChannelsFromHFNoise = union(badChannelsFromHFNoise, ...
          noisyOut.badChannelsFromHFNoise);
      badChannelsFromCorrelation = union(badChannelsFromCorrelation, ...
          noisyOut.badChannelsFromCorrelation);
      badChannelsFromDeviation = union(badChannelsFromDeviation, ...
          noisyOut.badChannelsFromDeviation);
      badChannelsFromRansac = union(badChannelsFromRansac, ...
          noisyOut.badChannelsFromRansac);
      badChannelsFromDropOuts = union(badChannelsFromDropOuts, ...
          noisyOut.badChannelsFromDropOuts);
      if length(sourceChannels)  < 2
          error('robustReference:TooManyBad', ...
              'Could not perform a robust reference -- not enough good channels');
      end
      signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
      averageReference = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
      signalTmp = removeReference(signalTmp, averageReference, ...
                                 referenceOut.rereferencedChannels);
      fprintf('Interpolated channels: %s\n', getListString(noisyChannels));
      actualIterations = actualIterations + 1;
end
signal = signalTmp;

referenceOut.interpolatedChannelsFromNaNs = ...
    union(noisyOut.badChannelsFromNaNs, badChannelsFromNaNs);
referenceOut.interpolatedChannelsFromNoData = ...
    union(noisyOut.badChannelsFromNoData, badChannelsFromNoData);
referenceOut.interpolatedChannelsFromHFNoise = ...
    union(noisyOut.badChannelsFromHFNoise, badChannelsFromHFNoise);
referenceOut.interpolatedChannelsFromCorrelation = ...
    union(noisyOut.badChannelsFromCorrelation, badChannelsFromCorrelation);
referenceOut.interpolatedChannelsFromDeviation = ...
    union(noisyOut.badChannelsFromDeviation, badChannelsFromDeviation);
referenceOut.interpolatedChannelsFromRansac = ...
    union(noisyOut.badChannelsFromRansac, badChannelsFromRansac);
referenceOut.interpolatedChannelsFromDropOuts = noisyOut.badChannelsFromDropOuts;
referenceOut.interpolatedChannels = noisyChannels;
noisyOut = findNoisyChannels(signal, referenceIn);
referenceOut.channelsStillBad = noisyOut.noisyChannels;

referenceOut.noisyOut = noisyOut;
referenceOut.referenceSignal = averageReference;
referenceOut.actualReferenceIterations = actualIterations;

