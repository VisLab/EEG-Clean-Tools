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
%% Robust channel deviation (original)
tString = 'Robust channel deviation';
dataOriginal = original.robustChannelDeviation;
dataReferenced = referenced.robustChannelDeviation;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Robust channel deviation (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% HF noise Z-score (original)
tString = 'Z-score HF SNR';
dataOriginal = original.zscoreHFNoise;
dataReferenced = referenced.zscoreHFNoise;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% HF noise Z-score (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% Median max correlation (original)
tString = 'Median max correlation';
dataOriginal = original.medianMaxCorrelation;
dataReferenced = referenced.medianMaxCorrelation;
clim = [0, 1];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Median max correlation (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
 
%% Bad ransac fraction (original)
tString = 'Ransac fraction failed';
dataOriginal = original.ransacBadWindowFraction;
dataReferenced = referenced.ransacBadWindowFraction;
clim = [0, 1];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
%% Bad ransac fraction (referenced)
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
 
  



