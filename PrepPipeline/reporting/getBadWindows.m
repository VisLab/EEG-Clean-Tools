function [windowValues, windowSeconds, threshold] = ...
                              getBadWindows(noisyStatistics, type)
% Return the window values for a particular type of noisiness:
%
% Parameters:
%    noisyStatistics  Structure containing the noisy window calculations
%    type             String indicating type of noisiness: 
%                     'deviation', 'correlation', highfrequency, 'ransac' 
%    windowValues     (output) Values of the statistic in each window
%    windowSeconds    (output) Length of each window in seconds
%    threshhold       (output) Threshold above which window is considered bad
%
windowValues = [];
windowSeconds = 0;
threshold = 0;
switch lower(type)
    case 'deviation'
        deviations = noisyStatistics.channelDeviations;
        medianDeviations = median(deviations(:));
        sdDeviations = mad(deviations(:), 1)*1.4826;
        windowValues = (deviations - medianDeviations)./sdDeviations;
        threshold =  noisyStatistics.robustDeviationThreshold;
        windowSeconds = noisyStatistics.correlationWindowSeconds;
    case 'correlation'
        windowValues = 1 - noisyStatistics.maximumCorrelations;
        threshold = 1 - noisyStatistics.correlationThreshold;
        windowSeconds = noisyStatistics.correlationWindowSeconds;
    case 'highfrequency'
        noiseLevels = noisyStatistics.noiseLevels;
        medianNoise = median(noiseLevels(:));
        sdNoise = mad(noiseLevels(:), 1)*1.4826;
        windowValues = (noiseLevels - medianNoise)./sdNoise;
        threshold = noisyStatistics.highFrequencyNoiseThreshold;
        windowSeconds = noisyStatistics.correlationWindowSeconds;
    case 'ransac'
        windowValues = 1 - noisyStatistics.ransacCorrelations;
        threshold = 1 - noisyStatistics.ransacCorrelationThreshold;
        windowSeconds = noisyStatistics.ransacWindowSeconds;
end