function [] = showReferenced(summaryFile, reference, dname, srate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
headColor = [0.7, 0.7, 0.7];
elementColor = [0, 0, 0];
showColorbar = true;
scalpMapInterpolation = 'v4';

original = reference.noisyOutOriginal;
referenced = reference.noisyOut;
channelInformation = reference.channelInformation;
nosedir = channelInformation.nosedir;
channelLocations = reference.channelLocations;
originalLocations = ...
        getReportChannelInformation(channelLocations, original);
referencedLocations = ...
        getReportChannelInformation(channelLocations, referenced);
referenceChannels = reference.referenceChannels;
%% Scalp map of robust channel deviation (original)
tString = 'Robust channel deviation';
dataOriginal = original.robustChannelDeviation;
dataReferenced = referenced.robustChannelDeviation;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

if reference.dumpOrdinaryReference
    dataOriginalRef = reference.noisyOutOriginalRef.robustChannelDeviation;
    plotScalpMap(dataOriginalRef, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(originalref)'])
end
%% Scalp map of robust channel deviation (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])


%% Scalp map of HF noise Z-score (original)
tString = 'Z-score HF SNR';
dataOriginal = original.zscoreHFNoise;
dataReferenced = referenced.zscoreHFNoise;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

if reference.dumpOrdinaryReference
    dataOriginalRef = reference.noisyOutOriginalRef.zscoreHFNoise;
    plotScalpMap(dataOriginalRef, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(originalref)'])
end
%% Scalp map of HF noise Z-score (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% Scalp map of median max correlation (original)
tString = 'Median max correlation';
dataOriginal = original.medianMaxCorrelation;
dataReferenced = referenced.medianMaxCorrelation;
clim = [0, 1];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

if reference.dumpOrdinaryReference
    dataOriginalRef = reference.noisyOutOriginalRef.medianMaxCorrelation;
    plotScalpMap(dataOriginalRef, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(originalref)'])
end
%% Scalp map of median max correlation (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
 
%% Scalp map of bad ransac fraction (original)
tString = 'Ransac fraction failed';
dataOriginal = original.ransacBadWindowFraction;
dataReferenced = referenced.ransacBadWindowFraction;
clim = [0, 1];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

if reference.dumpOrdinaryReference
    dataOriginalRef = reference.noisyOutOriginalRef.ransacBadWindowFraction;
    plotScalpMap(dataOriginalRef, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(originalref)'])
end
%% Scalp map of bad ransac fraction (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
 
  
%% Channels with bad noise levels before and after reference
legendStrings = {'Before referencing', 'After referencing'};
beforeNoise = original.noiseLevels(referenceChannels, :);
beforeNoise = sum(beforeNoise >= original.highFrequencyNoiseThreshold);
afterNoise = referenced.noiseLevels(referenceChannels, :);
afterNoise = sum(afterNoise >= referenced.highFrequencyNoiseThreshold);
beforeTimeScale = (0:length(beforeNoise)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterNoise)-1)*referenced.correlationWindowSeconds;
thresholdName = 'HF noise threshold';
[beforeHFFraction, afterHFFraction] = ...
    showBadWindows(beforeNoise, afterNoise, beforeTimeScale, afterTimeScale, ...
     length(referenceChannels), legendStrings, dname, thresholdName);
writeSummaryItem(summaryFile, ...
   {['Average fraction of channels with HF noise (over ' ...
   num2str(size(referenced.noiseLevels, 2)) ' windows)  [before=', ...
   num2str(beforeHFFraction) ', after=' num2str(afterHFFraction) ']']});
%% Channels with large robust deviation before and after reference
beforeDeviation = original.channelDeviations(referenceChannels, :);
beforeDeviation = sum(beforeDeviation >= original.robustDeviationThreshold);
afterDeviation = referenced.channelDeviations(referenceChannels, :);
afterDeviation = sum(afterDeviation >= referenced.robustDeviationThreshold);
beforeTimeScale = (0:length(beforeDeviation)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterDeviation)-1)*referenced.correlationWindowSeconds;
thresholdName = 'robust amplitude threshold';
[beforeAmpFraction, afterAmpFraction] = ...
    showBadWindows(beforeDeviation, afterDeviation, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, dname, thresholdName);
writeSummaryItem(summaryFile, ...
   {['Average fraction of channels with large amplitude (over ' ...
   num2str(size(referenced.channelDeviations, 2)) ' windows)  [before=', ...
   num2str(beforeAmpFraction) ', after=' num2str(afterAmpFraction) ']']});              
%% Channels with low median max correlation before and after reference
beforeCorrelation = original.maximumCorrelations(referenceChannels, :);
beforeCorrelation = sum(beforeCorrelation < original.correlationThreshold);
afterCorrelation = referenced.maximumCorrelations(referenceChannels, :);
afterCorrelation = sum(afterCorrelation < referenced.correlationThreshold);
beforeTimeScale = (1:length(beforeCorrelation))*original.correlationWindowSeconds;
afterTimeScale = (1:length(afterCorrelation))*referenced.correlationWindowSeconds;
thresholdName = 'median max correlation threshold';
[beforeCorrFraction, afterCorrFraction] = ...
    showBadWindows(beforeCorrelation, afterCorrelation, beforeTimeScale, afterTimeScale, ...
   length(referenceChannels), legendStrings, dname, thresholdName);
writeSummaryItem(summaryFile, ...
   {['Average fraction of channels low correlation (over ' ...
   num2str(size(referenced.maximumCorrelations, 2)) ' windows) [before=', ...
   num2str(beforeCorrFraction) ', after=' num2str(afterCorrFraction) ']']}); 
%% Channels with poor ransac correlations before and after reference
beforeRansac = original.ransacCorrelations(referenceChannels, :);
beforeRansac = sum(beforeRansac < original.ransacCorrelationThreshold);
afterRansac = referenced.ransacCorrelations(referenceChannels, :);
afterRansac = sum(afterRansac < referenced.ransacCorrelationThreshold);
beforeTimeScale = (1:length(beforeRansac))*original.ransacWindowSeconds;
afterTimeScale = (1:length(afterRansac))*referenced.ransacWindowSeconds;
thresholdName = 'ransac correlation threshold';
[beforeRanFraction, afterRanFraction] = ....
    showBadWindows(beforeRansac, afterRansac, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, dname, thresholdName);
writeSummaryItem(summaryFile, ...
   {['Average fraction of channels with poor predictability (over ' ...
   num2str(size(referenced.ransacCorrelations, 2)) ' windows)  [before=', ...
   num2str(beforeRanFraction) ', after=' num2str(afterRanFraction) ']']}); 

%% Comparison of noisy average reference and robust average reference
corrAverage = corr(reference.averageReference(:), ...
         reference.averageReferenceWithNoisyChannels(:));
tString = { dname, ...
    ['Comparison of reference signals (corr=' num2str(corrAverage) ')']}; 
figure('Name', tString{2})
plot(reference.averageReference, ...
     reference.averageReferenceWithNoisyChannels, '.k');
xlabel('Robust reference')
ylabel('Noisy reference');
title(tString, 'Interpreter', 'None');
writeSummaryItem(summaryFile, ...
   {['Correlation between noisy and robust reference: ' num2str(corrAverage)]});
%% Comparison of noisy average reference and robust average reference
tString = { dname, 'noisy - robust reference signals'}; 
t = (0:length(reference.averageReference) - 1)/srate;
figure('Name', tString{2})
plot(t, reference.averageReferenceWithNoisyChannels - ...
     reference.averageReference, '.k');
xlabel('seconds')
ylabel('Difference');
title(tString, 'Interpreter', 'None');



