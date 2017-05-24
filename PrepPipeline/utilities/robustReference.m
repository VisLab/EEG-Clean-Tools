function referenceOut = robustReference(signal, referenceOut)
% Robustly estimate of bad channels by iteratively interpolating channels
%
% This function finds bad channels by iteratively interpolating the
% bad list so far and calculating a mean of good signals. It assumes
% that defaults have already been checked on referenceIn.
%
% Parameters (input):
%     signal        structure with data field (assumes unfiltered)
%     referenceOut  structure with reference parameters with reference
%                  parameters in it.
%
% Parameters (output):
%     referenceOut  the referenceOut structure filled in  


%% Warn if evaluation and reference channels are not the same for robust
if ~isempty( ...
    setdiff(referenceOut.evaluationChannels,referenceOut.referenceChannels)) ...
    || ~isempty( ...
    setdiff(referenceOut.referenceChannels, referenceOut.evaluationChannels))
    warning('robustReference:EvaluationChannels', ...
    'Reference and evaluation channels should be same for robust reference');
end
   
%% Determine unusable channels and remove them from the reference channels
signal = removeTrend(signal, referenceOut);
referenceOut.noisyStatisticsOriginal = findNoisyChannels(signal, referenceOut);
referenceOut.noisyStatistics = referenceOut.noisyStatisticsOriginal;  
[badChannelsFromNaNs, badChannelsFromNoData] = ...
               findUnusableChannels(signal, referenceOut.referenceChannels); 
noisy = referenceOut.noisyStatisticsOriginal.noisyChannels;
badChannelsFromLowSNR = noisy.badChannelsFromLowSNR;
unusableChannels = union(badChannelsFromNaNs, ...
    union(badChannelsFromNoData, badChannelsFromLowSNR));
unusableChannels = unusableChannels(:)';
referenceOut.badChannels.badChannelsFromNaNs = ...
    badChannelsFromNaNs(:)';
referenceOut.badChannels.badChannelsFromNoData = ...
    badChannelsFromNoData(:)';
referenceOut.badChannels.badChannelsFromLowSNR = ...
    badChannelsFromLowSNR(:)';
referenceChannels = setdiff(referenceOut.referenceChannels, unusableChannels);

%% Get initial estimate of the mean by the specified method
if strcmpi(referenceOut.meanEstimateType, 'median')
    refTemp = median(signal.data(referenceChannels, :), 1);
    signalTmp = removeReference(signal, refTemp, referenceChannels);
elseif strcmpi(referenceOut.meanEstimateType, 'mean')
    refTemp = mean(signal.data(referenceChannels, :), 1);
    signalTmp = removeReference(signal, refTemp, referenceChannels);
elseif strcmpi(referenceOut.meanEstimateType, 'huber')
    signalTmp = removeHuberMean(signal, referenceChannels);
else
    signalTmp = signal;
end

%% Remove reference from signal iteratively interpolating bad channels
iterations = 0;                         
noisyChannelsOld = [];
while true  % Do at least 1 iteration
    noisyStatistics = findNoisyChannels(signalTmp, referenceOut);
    referenceOut.badChannels = ...
        updateBadChannels(referenceOut.badChannels, noisyStatistics.noisyChannels);
    noisyChannels = referenceOut.badChannels.all(:)';
    if (iterations > 1  && (isempty(noisyChannels) ||...
       (isempty(setdiff(noisyChannels, noisyChannelsOld)) ...
        && isempty(setdiff(noisyChannelsOld, noisyChannels))))) || ...
        iterations > referenceOut.maxReferenceIterations 
        break;
    end    
    noisyChannelsOld = noisyChannels; 
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    if length(sourceChannels)  < 2
        error('robustReference:TooManyBad', ...
            'Could not perform a robust reference -- not enough good channels');
    end
    if ~isempty(noisyChannels)
        signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
    else
        signalTmp = signal;
    end
    referenceSignal = nanmean(signalTmp.data(referenceChannels, :), 1);
    signalTmp = removeReference(signal, referenceSignal, referenceChannels);
    iterations = iterations + 1;
    fprintf('Iteration: %d\n', iterations);
end
referenceOut.actualReferenceIterations = iterations;
referenceOut.noisyStatistics = noisyStatistics;
fprintf('Robust reference done');
