%% Visualize the EEG 
% The reporting function expects that EEG will be in the base workspace
% with an EEG.etc.noisyParameters structure containing the report. It
% also expects the following variables in the base workspace:
% 
% * summaryReportName name of the summary report
% * summaryFolder folder where summary report goes
% * sessionFolder folder where specific report goes
% * sessionReportName name of individual report
% 
% The reporting function appends a summary to the summary report. 

%% Open summary report file and write data status
summaryReportLocation = [summaryFolder filesep summaryReportName];
summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
relativeReportLocation = [sessionFolder filesep sessionReportName];
consoleFID = 1;

% Output the report header
noisyParameters = EEG.etc.noisyParameters;
summaryHeader = [noisyParameters.name '[' ...
    num2str(size(EEG.data, 1)) ' channels, ' num2str(size(EEG.data, 2)) ' frames]'];
summaryHeader = [summaryHeader ' <a href="' relativeReportLocation ...
    '">Report details</a>'];
writeSummaryHeader(summaryFile,  summaryHeader);
writeSummaryItem(summaryFile, '', 'first');

%  Write overview status
errorStatus = ['Error status: ' noisyParameters.errors.status];
fprintf(consoleFID, '%s \n', errorStatus);
writeSummaryItem(summaryFile, {errorStatus});
  
% Setup visualization parameters
numbersPerRow = 15;
indent = '  ';
colors = [0, 0, 0; 1, 0, 0];
legendStrings = {'Before referencing', 'After referencing'};

%% Report high pass filtering step
summary = reportHighPass(consoleFID, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);
%% Report line noise removal step
summary = reportLineNoise(consoleFID, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);

%% Spectrum after line noise removal
if isfield(noisyParameters, 'lineNoise')
    lineChannels = noisyParameters.lineNoise.lineNoiseChannels; 
    numChans = min(6, length(lineChannels));
    indexchans = floor(linspace(1, length(lineChannels), numChans));
    channels = lineChannels(indexchans);
    channelLabels = {EEG.chanlocs(channels).labels};
    tString = noisyParameters.name;
    showSpectrum(EEG, channels, channelLabels, tString);
end
%% Report referencing step 
summary = reportReferenced(consoleFID, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);
if ~isfield(noisyParameters, 'reference')
    writeSummaryItem(summaryFile, '', 'last');
    fclose(summaryFile);
end
reference = noisyParameters.reference;
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
medOrig = original.channelDeviationMedian;
sdnOrig = original.channelDeviationSD;
medRef = referenced.channelDeviationMedian;
sdnRef = referenced.channelDeviationSD;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% Robust channel deviation (referenced)
dataReferenced = ((dataReferenced*sdnRef + medRef) - medOrig)/sdnOrig;
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% Robust deviation window statistics
medOrig = original.channelDeviationMedian;
sdnOrig = original.channelDeviationSD;
beforeDeviationLevels = original.channelDeviations(referenceChannels, :);
afterDeviationLevels = referenced.channelDeviations(referenceChannels, :);
beforeDeviation = (beforeDeviationLevels - medOrig)./sdnOrig; 
afterDeviation = (afterDeviationLevels - medOrig)./sdnOrig;
thresholdName = 'Deviation score';
theTitle = char([noisyParameters.name ': ' thresholdName ' distribution']);
showCumulativeDistributions({beforeDeviation(:), afterDeviation(:)}, ...
    thresholdName, colors, theTitle, legendStrings, [-5, 5]);

beforeDeviation = sum(beforeDeviation >= original.robustDeviationThreshold);
afterDeviation = sum(afterDeviation >= referenced.robustDeviationThreshold);
beforeTimeScale = (0:length(beforeDeviation)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterDeviation)-1)*referenced.correlationWindowSeconds;
[beforeAmpFraction, afterAmpFraction] = ...
    showBadWindows(beforeDeviation, afterDeviation, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);

report0 = ['Deviation window statistics ((over ' ...
           num2str(size(referenced.channelDeviations, 2)) ' windows)']; 
report1 = ['Large deviation channel fraction [before=', ...
           num2str(beforeAmpFraction) ', after=' num2str(afterAmpFraction) ']'];
report2 = ['Median channel deviation: [before=', ...
          num2str(original.channelDeviationMedian) ...
          ', after=' num2str(referenced.channelDeviationMedian) ']'];
report3 = ['SD channel deviation: [before=', ...
          num2str(original.channelDeviationSD) ...
          ', after=' num2str(referenced.channelDeviationSD) ']'];
report4 = ['Max raw deviation level [before=', ...
          num2str(max(beforeDeviationLevels(:))) ', after=' ...
          num2str(max(afterDeviationLevels(:))) ']'];
quarterChannels = round(length(referenceChannels)*0.25);
halfChannels = round(length(referenceChannels)*0.5);
report5 = ['Windows with > 1/4 deviation channels [before=', ...
          num2str(sum(beforeDeviation > quarterChannels)) ...
          ', after=' num2str(sum(afterDeviation > quarterChannels)) ']'];
report6 = ['Windows with > 1/2 deviation channels [before=', ...
          num2str(sum(beforeDeviation > halfChannels)) ...
          ', after=' num2str(sum(afterDeviation > halfChannels)) ']'];
fprintf(consoleFID, '%s:\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n', report0, ...
          indent, report1, indent, report2, indent, report3, ...
          indent, report4, indent, report5, indent, report6);
writeSummaryItem(summaryFile, {report1});
writeSummaryItem(summaryFile, {report2});
writeSummaryItem(summaryFile, {report3});

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

%% Correlation window statistics
beforeCorrelationLevels = original.maximumCorrelations(referenceChannels, :);
afterCorrelationLevels = referenced.maximumCorrelations(referenceChannels, :);
thresholdName = 'Maximum correlation';
theTitle = char([noisyParameters.name ': ' thresholdName ' distribution']);
showCumulativeDistributions({beforeCorrelationLevels(:), afterCorrelationLevels(:)}, ...
    thresholdName, colors, theTitle, legendStrings, [0, 1]);

beforeCorrelation = sum(beforeCorrelationLevels <= original.correlationThreshold);
afterCorrelation = sum(afterCorrelationLevels <= referenced.correlationThreshold);
beforeTimeScale = (0:length(beforeCorrelation)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterCorrelation)-1)*referenced.correlationWindowSeconds;
[beforeCorrFraction, afterCorrFraction] = ...
    showBadWindows(beforeCorrelation, afterCorrelation, beforeTimeScale, afterTimeScale, ...
   length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);

report0 = ['Max correlation window statistics ((over ' ...
           num2str(size(referenced.maximumCorrelations, 2)) ' windows)']; 
report1 = ['Overall median maximum correlation [before=', ...
           num2str(median(original.medianMaxCorrelation(:))) ...
           ', after=' num2str(median(referenced.medianMaxCorrelation(:))) ']'];       
report2 = ['Low max correlation fraction [before=', ...
          num2str(beforeCorrFraction) ', after=' num2str(afterCorrFraction) ']'];
report3 = ['Minimum max correlation level [before=', ...
           num2str(max(beforeCorrelationLevels(:))) ', after=' ...
          num2str(max(afterCorrelationLevels(:))) ']'];
quarterChannels = round(length(referenceChannels)*0.25);
halfChannels = round(length(referenceChannels)*0.5);
report4 = ['Windows with > 1/4 bad channels [before=', ...
          num2str(sum(beforeCorrelation > quarterChannels)) ...
          ', after=' num2str(sum(afterCorrelation > quarterChannels)) ']'];
report5 = ['Windows with > 1/2 bad channels [before=', ...
          num2str(sum(beforeCorrelation > halfChannels)) ...
          ', after=' num2str(sum(afterCorrelation > halfChannels)) ']'];
fprintf(consoleFID, '%s:\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n', ...
          report0, indent, report1, indent, report2, ...
          indent, report3, indent, report4, indent, report5);
writeSummaryItem(summaryFile, {report1});
writeSummaryItem(summaryFile, {report2});
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

%% Channels with poor ransac correlations 
beforeRansacLevels = original.ransacCorrelations(referenceChannels, :);
afterRansacLevels = referenced.ransacCorrelations(referenceChannels, :);
thresholdName = 'Ransac correlation';
theTitle = char([noisyParameters.name ': ' thresholdName ' distribution']);
showCumulativeDistributions({beforeRansacLevels(:), afterRansacLevels(:)}, ...
    thresholdName, colors, theTitle, legendStrings, [0, 1]);

beforeRansac = sum(beforeRansacLevels <= original.ransacCorrelationThreshold);
afterRansac = sum(afterRansacLevels <= referenced.ransacCorrelationThreshold);
beforeTimeScale = (0:length(beforeRansac)-1)*original.ransacWindowSeconds;
afterTimeScale = (0:length(afterRansac)-1)*referenced.ransacWindowSeconds;
[beforeRanFraction, afterRanFraction] = ....
    showBadWindows(beforeRansac, afterRansac, beforeTimeScale, afterTimeScale, ...
      length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);

report0 = ['Ransac window statistics ((over ' ...
           num2str(size(afterRansacLevels, 2)) ' windows)']; 
report1 = ['Low ransac channel fraction [before=', ...
   num2str(beforeRanFraction) ', after=' num2str(afterRanFraction) ']'];
report2 = ['Minimum ransac correlation [before=', ...
   num2str(min(beforeRansacLevels(:))) ', after=' ...
   num2str(min(afterRansacLevels(:))) ']'];
quarterChannels = round(length(referenceChannels)*0.25);
halfChannels = round(length(referenceChannels)*0.5);
report3 = ['Windows with > 1/4 bad ransac channels [before=', ...
          num2str(sum(beforeRansac > quarterChannels)) ...
          ', after=' num2str(sum(afterRansac > quarterChannels)) ']'];
report4 = ['Windows with > 1/2 bad ransac channels [before=', ...
          num2str(sum(beforeRansac > halfChannels)) ...
          ', after=' num2str(sum(afterRansac > halfChannels)) ']'];
fprintf(consoleFID, '%s:\n%s%s\n%s%s\n%s%s\n%s%s\n', report0, indent, report1, ...
          indent, report2, indent, report3, indent, report4);
writeSummaryItem(summaryFile, {report1});

%% HF noise Z-score (original)
tString = 'Z-score HF SNR';
dataOriginal = original.zscoreHFNoise;
dataReferenced = referenced.zscoreHFNoise;
medOrig = original.noisinessMedian;
sdnOrig = original.noisinessSD;
medRef = referenced.noisinessMedian;
sdnRef = referenced.noisinessSD;
scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
clim = [-scale, scale];

plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])

%% HF noise Z-score (referenced)
dataReferenced = ((dataReferenced*sdnRef + medRef) - medOrig)/sdnOrig;
plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
    showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])

%% HF noise window stats
beforeNoiseLevels = original.noiseLevels(referenceChannels, :);
afterNoiseLevels = referenced.noiseLevels(referenceChannels, :);
medianNoiseOrig = median(beforeNoiseLevels(:));
sdNoiseOrig = mad(beforeNoiseLevels(:), 1)*1.4826;
medianNoiseRef = median(afterNoiseLevels(:));
sdNoiseRef = mad(afterNoiseLevels(:), 1)*1.4826;
beforeNoise = (beforeNoiseLevels - medianNoiseOrig)./sdNoiseOrig; 
afterNoise = (afterNoiseLevels - medianNoiseOrig)./sdNoiseOrig;
thresholdName = 'HF noise';
theTitle = char([noisyParameters.name ': ' thresholdName ' HF noise distribution']);
showCumulativeDistributions({beforeNoise(:), afterNoise(:)},thresholdName, ...
                             colors, theTitle, legendStrings, [-5, 5]);

beforeNoise = sum(beforeNoise  >= original.highFrequencyNoiseThreshold);
afterNoise = sum(afterNoise >= referenced.highFrequencyNoiseThreshold);
beforeTimeScale = (0:length(beforeNoise)-1)*original.correlationWindowSeconds;
afterTimeScale = (0:length(afterNoise)-1)*referenced.correlationWindowSeconds;
[beforeHFFraction, afterHFFraction] = ...
    showBadWindows(beforeNoise, afterNoise, beforeTimeScale, afterTimeScale, ...
     length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
report0 = ['Noise window statistics ((over ' ...
           num2str(size(referenced.noiseLevels, 2)) ' windows)']; 
report1 = ['Channel fraction with HF noise [before=', ...
           num2str(beforeHFFraction) ', after=' num2str(afterHFFraction) ']'];
report2 = ['Median noisiness: [before=', ...
          num2str(original.noisinessMedian) ...
          ', after=' num2str(referenced.noisinessMedian) ']'];
report3 = ['SD noisiness: [before=', ...
          num2str(original.noisinessSD) ...
          ', after=' num2str(referenced.noisinessSD) ']'];
report4 = ['Max HF noise levels [before=', ...
          num2str(max(beforeNoiseLevels(:))) ', after=' ...
          num2str(max(afterNoiseLevels(:))) ']'];
quarterChannels = round(length(referenceChannels)*0.25);
halfChannels = round(length(referenceChannels)*0.5);
report5 = ['Windows with > 1/4 HF channels [before=', ...
          num2str(sum(beforeNoise > quarterChannels)) ...
          ', after=' num2str(sum(afterNoise > quarterChannels)) ']'];
report6 = ['Windows with > 1/2 HF channels [before=', ...
          num2str(sum(beforeNoise > halfChannels)) ...
          ', after=' num2str(sum(afterNoise > halfChannels)) ']'];
report7 = ['Median window HF [before=', ...
          num2str(medianNoiseOrig) ', after=' num2str(medianNoiseRef) ']'];
report8 = ['SD window HF [before=', ...
          num2str(sdNoiseOrig) ', after=' num2str(sdNoiseRef) ']'];
fprintf(consoleFID, '%s:\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n%s%s\n', report0, ...
          indent, report1, indent, report2, indent, report3, indent, ...
          report4, indent, report5, indent, report6, ...
          indent, report7, indent, report8);

writeSummaryItem(summaryFile, {report1});
writeSummaryItem(summaryFile, {report2});
writeSummaryItem(summaryFile, {report3});
%% Noisy average reference vs robust average reference
corrAverage = corr(reference.averageReference(:), ...
         reference.averageReferenceWithNoisyChannels(:));
tString = { noisyParameters.name, ...
    ['Comparison of reference signals (corr=' num2str(corrAverage) ')']}; 
figure('Name', tString{2})
plot(reference.averageReference, ...
     reference.averageReferenceWithNoisyChannels, '.k');
xlabel('Robust reference')
ylabel('Noisy reference');
title(tString, 'Interpreter', 'None');
writeSummaryItem(summaryFile, ...
   {['Correlation between noisy and robust reference: ' num2str(corrAverage)]});

%% Noisy average reference - robust average reference by time
tString = { noisyParameters.name, 'noisy - robust reference signals'}; 
t = (0:length(reference.averageReference) - 1)/EEG.srate;
figure('Name', tString{2})
plot(t, reference.averageReferenceWithNoisyChannels - ...
     reference.averageReference, '.k');
xlabel('seconds')
ylabel('Difference');
title(tString, 'Interpreter', 'None');

writeSummaryItem(summaryFile, '', 'last');
fclose(summaryFile);