function [statisticsTitles,statisticsIndex,  statistics, ...
    noisyChannels] = extractReferenceStatistics(EEG)

    statisticsTitles = { ...
        'Median channel deviation original', ...
        'Median channel deviation referenced', ...
        'Robust SD channel deviation original', ...
        'Robust SD channel deviation, referenced', ...
        'Median window channel deviation original', ...
        'Median window channel deviation referenced', ...
        'Robust SD window channel deviation original', ...
        'Robust SD window channel deviation, referenced', ...
        'Median window correlation original', ...
        'Median window correlation referenced', ...
        'Average window correlation original', ...
        'Average window correlation referenced', ...
        'Median HF noisiness original', ...
        'Median HF noisiness referenced', ...
        'Robust SD HF noisiness original', ...
        'Robust SD HF noisiness referenced', ...
        'Median window HF noisiness original', ...
        'Median window HF noisiness referenced', ...
        'Robust window SD HF noisiness original', ...
        'Robust window SD HF noisiness referenced', ...
        };
    s = struct();
    s.medDevOrig = 1;
    s.medDevRef = 2;
    s.rSDDevOrig = 3;
    s.rSDDevRef = 4;
    s.medWinDevOrig = 5;
    s.medWinDevRef = 6;
    s.rSDWinDevOrig = 7;
    s.rSDWinDevRef = 8;
    s.medCorOrig = 9;
    s.medCorRef = 10;
    s.aveCorOrig = 11;
    s.aveCorRef = 12;
    s.medHFOrig = 13;
    s.medHFRef = 14;
    s.rSDHFOrig = 15;
    s.rSDHFRef = 16;
    s.medWinHFOrig = 17;
    s.medWinHFRef = 18;
    s.rSDWinHFOrig = 19;
    s.rSDWinHFRef = 20;
    statisticsIndex = s;
    if nargin < 1
        statistics = [];
        noisyChannels = struct();
        return;
    end

    statistics = zeros(1, length(statisticsTitles));
    reference = EEG.etc.noisyParameters.reference;
    original = reference.noisyOutOriginal;
    referenced = reference.noisyOut;
    if isempty(referenced.noisyChannels)
        noisyChannels = [];
    else
        noisyChannels = ...
            struct('badChannelNumbers', [], 'badChannelLabels', [], ...
              'badInterpolated', [], 'badNotInterpolated', [], ...
              'badNaN', [], 'badNoData', [], 'badDropOuts', [], ... 
              'badCorr', [],'badDev', [], 'badRansac', [], 'badHF',  []);
        channelLabels = {reference.channelLocations.labels};
        noisyChannels.badChannelNumbers = referenced.noisyChannels;
        noisyChannels.badChannelLabels = channelLabels(referenced.noisyChannels);
        noisyChannels.badInterpolated = reference.interpolatedChannels;
        noisyChannels.badNotInterpolated = reference.badChannelsNotInterpolated;
        noisyChannels.badNaN = ...
            getFieldIfExists(referenced, 'badChannelsFromNaNs');
        noisyChannels.badNoData = ...
            getFieldIfExists(referenced, 'badChannelsFromNoData');
        noisyChannels.badHF = ...
            getFieldIfExists(referenced, 'badChannelsFromHFNoise');
        noisyChannels.badCorr = ...
            getFieldIfExists(referenced, 'badChannelsFromCorrelation');
        noisyChannels.badDev = ...
            getFieldIfExists(referenced, 'badChannelsFromDeviation');
        noisyChannels.badRansac = ...
            getFieldIfExists(referenced, 'badChannelsFromRansac');
        noisyChannels.badDropOuts = ...
            getFieldIfExists(referenced, 'badChannelsFromDropOuts');
    end

%% Deviations
    referenceChannels = reference.referenceChannels;
    statistics(s.medDevOrig) = original.channelDeviationMedian;
    statistics(s.medDevRef) = referenced.channelDeviationMedian;
    statistics(s.rSDDevOrig) = original.channelDeviationSD;
    statistics(s.rSDDevRef) = referenced.channelDeviationSD;
    beforeDeviationLevels = original.channelDeviations(referenceChannels, :);
    afterDeviationLevels = referenced.channelDeviations(referenceChannels, :);
    statistics(s.medWinDevOrig) = median(beforeDeviationLevels(:));
    statistics(s.medWinDevRef) = median(afterDeviationLevels(:));
    statistics(s.rSDWinDevOrig) = mad(beforeDeviationLevels(:), 1)*1.4826;
    statistics(s.rSDWinDevRef) = mad(afterDeviationLevels(:), 1)*1.4826;
%% Correlations
    beforeCorrelation = original.maximumCorrelations(referenceChannels, :);
    afterCorrelation = referenced.maximumCorrelations(referenceChannels, :);
    statistics(s.medCorOrig) = median(beforeCorrelation(:));
    statistics(s.medCorRef) = median(afterCorrelation(:));
    statistics(s.aveCorOrig) = mean(beforeCorrelation(:));
    statistics(s.aveCorRef) = mean(afterCorrelation(:));

%% Noisiness
    statistics(s.medHFOrig) = original.noisinessMedian;
    statistics(s.medHFRef) = referenced.noisinessMedian;
    statistics(s.rSDHFOrig) = original.noisinessSD;
    statistics(s.rSDHFRef) = referenced.noisinessSD;
    beforeNoiseLevels = original.noiseLevels(referenceChannels, :);
    afterNoiseLevels = referenced.noiseLevels(referenceChannels, :);
    statistics(s.medWinHFOrig) = median(beforeNoiseLevels(:));
    statistics(s.medWinHFRef) = median(afterNoiseLevels(:));
    statistics(s.rSDWinHFOrig) = mad(beforeNoiseLevels(:), 1)*1.4826;
    statistics(s.rSDWinHFRef) = mad(afterNoiseLevels(:), 1)*1.4826;
end