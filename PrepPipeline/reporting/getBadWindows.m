function [windowValues, windowSeconds, threshhold] = getBadWindows(EEG, type)
% Return the window values for a particular type of noisiness:
%
% Parameters:
%    EEG    EEGLAB EEG structure with the PREP pipeline run on verbose
%    type   String indicating type of noisiness: 
%             'deviation', 'correlation', highfrequency, 'ransac' 
windowValues = [];
windowSeconds = 0;
threshhold = 0;

if ~isfield(EEG.etc, 'noiseDetection') || ...
   ~isfield(EEG.etc.noiseDetection, 'reference') || ...
   ~isfield(EEG.etc.noiseDetection.reference, 'noisyStatistics')
   warning('getBadWindows:PREPNotRun', ...
       'You must run the PREP pipeline to set the EEG metadata');
   return;
end

noisyStats = EEG.etc.noiseDetection.reference.noisyStatistics;
switch lower(type)
    case 'deviation'
        deviations = noisyStats.channelDeviations;
        medianDeviations = median(deviations(:));
        sdDeviations = mad(deviations(:), 1)*1.4826;
        windowValues = (deviations - medianDeviations)./sdDeviations;
        threshhold =  noisyStats.robustDeviationThreshold;
        windowSeconds = noisyStats.correlationWindowSeconds;
    case 'correlation'
        windowValues = 1 - noisyStats.maximumCorrelations;
        threshhold = 1 - noisyStats.correlationThreshold;
        windowSeconds = noisyStats.correlationWindowSeconds;
    case 'highfrequency'
        noiseLevels = noisyStats.noiseLevels;
        medianNoise = median(noiseLevels(:));
        sdNoise = mad(noiseLevels(:), 1)*1.4826;
        windowValues = (noiseLevels - medianNoise)./sdNoise;
        threshhold = noisyStats.highFrequencyNoiseThreshold;
        windowSeconds = noisyStats.correlationWindowSeconds;
    case 'ransac'
        windowValues = 1 - noisyStats.ransacCorrelations;
        threshhold = 1 - noisyStats.ransacCorrelationThreshold;
        windowSeconds = noisyStats.ransacWindowSeconds;
end