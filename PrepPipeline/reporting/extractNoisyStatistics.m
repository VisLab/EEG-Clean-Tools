function [statisticsTitles, statisticsIndex,  noisyChannels, ... 
                              statistics] = extractNoisyStatistics(noisy)
% Creates st
    statisticsTitles = { ...
        'Median channel deviation', ...
        'Robust SD channel deviation', ...
        'Median window channel deviation', ...
        'Robust SD window channel deviation', ...
        'Median window correlation', ...
        'Average window correlation', ...
        'Median HF noisiness', ...
        'Robust SD HF noisiness', ...
        'Median window HF noisiness', ...
        'Robust window SD HF noisiness', ...
        };
    s = struct();
    s.medDev = 1;
    s.rSDDev = 2;
    s.medWinDev = 3;
    s.rSDWinDev = 4;
    s.medCor = 5;
    s.aveCor = 6;
    s.medHF = 7;
    s.rSDHF = 8;
    s.medWinHF = 9;
    s.rSDWinHF = 10;
    statisticsIndex = s;
    noisyChannels = ...
            struct('evaluationChannels', [], ...
              'badChannelNumbers', [], 'badChannelLabels', [], ...
              'badNaN', [], 'badNoData', [], ...
              'badLowSNR', [], 'badDropOuts', [], ... 
              'badCorr', [],'badDev', [], ...
              'badRansac', [], 'badHF',  []);
    if nargin < 1
        statistics = [];
        return;
    end

    statistics = zeros(1, length(statisticsTitles));
%% Fill in the rest of the noisyChannels structure
    evaluationChannels = noisy.evaluationChannels;
    channelLabels = {noisy.channelLocations.labels};
    badchans = noisy.noisyChannels;
    bad = badchans.all;
    noisyChannels.evaluationChannels = evaluationChannels;
    noisyChannels.badChannelNumbers = bad(:)';
    noisyChannels.badChannelLabels = channelLabels(noisyChannels.badChannelNumbers);
 
    noisyChannels.badNaN = getFieldIfExists(badchans, 'badChannelsFromNaNs');
    noisyChannels.badNoData = getFieldIfExists(badchans, 'badChannelsFromNoData');
    noisyChannels.badLowSNR = getFieldIfExists(badchans, 'badChannelsFromLowSNR');
    noisyChannels.badHF = getFieldIfExists(badchans, 'badChannelsFromHFNoise');
    noisyChannels.badCorr = getFieldIfExists(badchans, 'badChannelsFromCorrelation');
    noisyChannels.badDev = getFieldIfExists(badchans, 'badChannelsFromDeviation');
    noisyChannels.badRansac = getFieldIfExists(badchans, 'badChannelsFromRansac');
    noisyChannels.badDropOuts = getFieldIfExists(badchans, 'badChannelsFromDropOuts');

%% Fill in deviation statistics
    statistics(s.medDev) = noisy.channelDeviationMedian;
    statistics(s.rSDDev) = noisy.channelDeviationSD;
    deviationLevels = noisy.channelDeviations(evaluationChannels, :);
    statistics(s.medWinDev) = median(deviationLevels(:));
    statistics(s.rSDWinDev) = mad(deviationLevels(:), 1)*1.4826;
  
%% Fill in correlations information
    correlations = noisy.maximumCorrelations(evaluationChannels, :);
    statistics(s.medCor) = median(correlations(:));
    statistics(s.aveCor) = mean(correlations(:));

%% Fill in noisiness information
    statistics(s.medHF) = noisy.noisinessMedian;
    statistics(s.rSDHF) = noisy.noisinessSD;
    noiseLevels = noisy.noiseLevels(evaluationChannels, :);
    statistics(s.medWinHF) = median(noiseLevels(:));
    statistics(s.rSDWinHF) = mad(noiseLevels(:), 1)*1.4826;
end