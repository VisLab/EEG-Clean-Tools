%% Visualize the EEG 
fprintf('%s...\n', EEG.etc.noisyParameters.name);

%% Setup visualization parameters
numbersPerRow = 15;
indent = '  ';
headColor = [0.7, 0.7, 0.7];
elementColor = [0, 0, 0];
showColorbar = true;
scalpMapInterpolation = 'v4';
noisyParameters = EEG.etc.noisyParameters;
original = noisyParameters.reference.noisyOutOriginal;
referenced = noisyParameters.reference.noisyOut;

[originalLocations, originalInformation, originalChannels] = ...
        getReportChannelInformation(original);
[referencedLocations, referencedInformation, referencedChannels] = ...
        getReportChannelInformation(referenced);
referenceChannels = noisyParameters.reference.referenceChannels;
%% Report high pass filtering step
reportHighPass(noisyParameters, numbersPerRow, indent);

%% Report line noise removal step
reportLineNoise(noisyParameters, numbersPerRow, indent);

%% Spectrum after line noise removal
channels = noisyParameters.lineNoise.lineNoiseChannels;
tString = noisyParameters.name;
showSpectrum(EEG, channels, tString);
%% Report rereferencing step parameters
reportRereference(noisyParameters, numbersPerRow, indent);

%% Scalp map of robust channel deviation (original)
tString = 'Robust channel deviation';
dataOriginal = original.robustChannelDeviation;
dataReferenced = referenced.robustChannelDeviation;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

nosedir = originalInformation.nosedir;
plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Scalp map of robust channel deviation (referenced)
nosedir = referencedInformation.nosedir;
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% Scalp map of HF noise Z-score (original)
tString = 'Z-score HF SNR';
dataOriginal = original.zscoreHFNoise;
dataReferenced = referenced.zscoreHFNoise;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

nosedir = originalInformation.nosedir;
plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Scalp map of HF noise Z-score (referenced)
nosedir = referencedInformation.nosedir;
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% Scalp map of median max correlation (original)
tString = 'Median max correlation';
dataOriginal = original.medianMaxCorrelation;
dataReferenced = referenced.medianMaxCorrelation;
clim = [0, 1];

nosedir = originalInformation.nosedir;
plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Scalp map of median max correlation (referenced)
nosedir = referencedInformation.nosedir;
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
 
%% Scalp map of bad ransac fraction (original)
tString = 'Ransac fraction failed';
dataOriginal = original.ransacBadWindowFraction;
dataReferenced = referenced.ransacBadWindowFraction;
clim = [0, 1];

nosedir = originalInformation.nosedir;
plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
%% Scalp map of bad ransac fraction (referenced)
nosedir = referencedInformation.nosedir;
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
showBadWindows(beforeNoise, afterNoise, beforeTimeScale, afterTimeScale, ...
     length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
              
%% Channels with large robust deviation before and after reference
beforeDeviation = original.channelDeviations(referenceChannels, :);
beforeDeviation = sum(beforeDeviation >= original.robustDeviationThreshold);
afterDeviation = referenced.channelDeviations(referenceChannels, :);
afterDeviation = sum(afterDeviation >= referenced.robustDeviationThreshold);
beforeTimeScale = (0:length(beforeDeviation)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterDeviation)-1)*referenced.correlationWindowSeconds;
thresholdName = 'robust amplitude threshold';
showBadWindows(beforeDeviation, afterDeviation, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
              
%% Channels with low median max correlation before and after reference
beforeCorrelation = original.maximumCorrelations(referenceChannels, :);
beforeCorrelation = sum(beforeCorrelation < original.correlationThreshold);
afterCorrelation = referenced.maximumCorrelations(referenceChannels, :);
afterCorrelation = sum(afterCorrelation < referenced.correlationThreshold);
beforeTimeScale = (1:length(beforeCorrelation))*original.correlationWindowSeconds;
afterTimeScale = (1:length(afterCorrelation))*referenced.correlationWindowSeconds;
thresholdName = 'median max correlation threshold';
showBadWindows(beforeCorrelation, afterCorrelation, beforeTimeScale, afterTimeScale, ...
   length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
%% Channels with poor ransac correlations before and after reference
beforeRansac = original.ransacCorrelations(referenceChannels, :);
beforeRansac = sum(beforeRansac < original.ransacCorrelationThreshold);
afterRansac = referenced.ransacCorrelations(referenceChannels, :);
afterRansac = sum(afterRansac < referenced.ransacCorrelationThreshold);
beforeTimeScale = (1:length(beforeRansac))*original.ransacWindowSeconds;
afterTimeScale = (1:length(afterRansac))*referenced.ransacWindowSeconds;
thresholdName = 'ransac correlation threshold';
showBadWindows(beforeRansac, afterRansac, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
