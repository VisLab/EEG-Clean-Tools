%% Visualize the EEG output from the PREP processing pipeline.
%
% Calling directly:
%      prepReport
%
% This helper reporting script expects that EEGReporting will be in the base workspace
% with an EEGReporting.etc.noiseDetection structure containing the report. It
% also expects the following variables in the base workspace:
% 
% * summaryFile - variable containing the open file descriptor for summary
% * consoleID  - variable with open file descriptor for console 
%                (usually 1 unless the output is redirected).
% * relativeReportLocation report location relative to summary
%
% The reporting function appends a summary to the summary report. 
%
% Usually the prepReport script is called through the function:
%
%        publishPrepReport 
%
% It is not a function itself, to allow the MATLAB publish to dump a nice
% output.
%
%% Write data status and report header
reference = struct();
version = '';
fullInformation = false;
numbersPerRow = 10;
indent = '  ';

if isfield(EEGReporting, 'etc') && isfield(EEGReporting.etc, 'noiseDetection')
    noiseDetection = EEGReporting.etc.noiseDetection;
else
    error('prepReport:NoNoiseDetection', ...
    'PREP reporting relies on EEGReporting.etc.noiseDetection which does not exist');
end
if isfield(noiseDetection, 'reference')
    reference = noiseDetection.reference;
end
if isfield(noiseDetection, 'version')
   version = EEGReporting.etc.noiseDetection.version;
end
if isfield(noiseDetection, 'fullReferenceInfo');
    fullInformation = EEGReporting.etc.noiseDetection.fullReferenceInfo;
end

[channels, frames] = size(EEGReporting.data);

fprintf(consoleFID, '%s\nChannels: %d\nFrames: %d\n', ...
    noiseDetection.name, channels, frames);
summaryHeader = [noiseDetection.name '[' ...
    num2str(channels) ' channels, ' num2str(frames) ' frames]'];
summaryHeader = [summaryHeader ' <a href="' relativeReportLocation ...
    '">Report details</a>'];
writeSummaryHeader(summaryFile,  summaryHeader);
originalChannelLabels = noiseDetection.originalChannelLabels;
originalMask = true(1, length(originalChannelLabels));
currentChannelLabels = {EEGReporting.chanlocs.labels};
[actualLabels, iorig, icurrent] = ...
    intersect(originalChannelLabels, currentChannelLabels);
currentChannelsInOriginal = sort(iorig);

%  Write overview status
[errorStatus, errors] = getErrors(noiseDetection);
writeSummaryHeader(summaryFile,  errorStatus, 'h4');
writeHtmlList(summaryFile, errors, 'both');
fprintf(consoleFID, '%s\n', errorStatus);
writeTextList(consoleFID, errors);

% Versions
writeSummaryHeader(summaryFile,  ['Prep version:' version], 'h4');
fprintf(consoleFID, 'Prep version: %s\n', version);

% Events
summaryMsg = ['Data summary: sampling rate ' num2str(EEGReporting.srate) 'Hz'];
writeSummaryHeader(summaryFile,  summaryMsg, 'h4');
fprintf(consoleFID, '%s\n', summaryMsg);
[summary, hardFrames] = reportEvents(consoleFID, EEGReporting);
writeHtmlList(summaryFile, summary, 'both');

% Interpolated channels for referencing
removedChannels = [];
interpolatedChannels = [];
stillNoisyChannels = [];
if isfield(noiseDetection, 'reference')
    writeSummaryHeader(summaryFile,  'Interpolated channels', 'h4');
    removedChannels = getFieldIfExists(noiseDetection, 'removedChannelNumbers');
    interpolatedChannels = getFieldIfExists(noiseDetection, 'interpolatedChannelNumbers');
    stillNoisyChannels = getFieldIfExists(noiseDetection, 'stillNoisyChannelNumbers');
    summaryItem = {['Channels interpolated during reference: [' ...
                    num2str(interpolatedChannels) ']']; ...
                   ['Channels still noisy after reference: [' ...
                   num2str(stillNoisyChannels) ']']; ...
                   ['Channels removed during post-process: [' ...
                    num2str(removedChannels) ']' ]};
    writeHtmlList(summaryFile, summaryItem, 'both');
    fprintf(consoleFID, 'Channels interpolated during reference:\n');
    printList(consoleFID, interpolatedChannels, numbersPerRow, indent);
    fprintf(consoleFID, 'Channels still noisy after reference:\n');
    printList(consoleFID, stillNoisyChannels, numbersPerRow, indent);
    fprintf(consoleFID, 'Channels removed during post-process:\n');
    printList(consoleFID, removedChannels, numbersPerRow, indent);
end

% Setup visualization parameters

colors = [0, 0, 0; 0, 1, 0; 1, 0, 0];
legendStrings = {'Original', 'Before interp' 'Final'};
symbols = {'+', 'x', 'o'};
scalpMapInterpolation = 'v4';
darkElementColor = [0.5, 0.5, 0.5];
headColor = [0.95, 0.95, 0.95];
elementColor = [0, 0, 0];

%% Line noise removal step
writeSummaryHeader(summaryFile,  'Line noise removal summary', 'h4');
summary = reportLineNoise(consoleFID, noiseDetection, numbersPerRow, indent);
writeHtmlList(summaryFile, summary, 'both');

%% Initial detrend for reference calculation
writeSummaryHeader(summaryFile,  'Detrend summary', 'h4');
summary = reportDetrend(consoleFID, noiseDetection, numbersPerRow, indent);
writeHtmlList(summaryFile, summary, 'both');

%% Spectrum after line noise and detrend
if ~isfield(noiseDetection, 'lineNoise')
   fprintf(consoleFID, 'Skipping line noise and detrend\n');
else
    lineChannels = noiseDetection.lineNoise.lineNoiseChannels;
    [chans, iorig, iline] = intersect(currentChannelsInOriginal, lineChannels);
    actualLineChannels = sort(iorig);
    numChans = min(6, length(actualLineChannels));
    indexchans = floor(linspace(1, length(actualLineChannels), numChans));
    displayChannels = lineChannels(indexchans);
    channelLabels = {EEGReporting.chanlocs(actualLineChannels).labels};
    tString = noiseDetection.name;
    if isfield(noiseDetection, 'detrend')
       detrend = noiseDetection.detrend;
       detrendChannels = detrend.detrendChannels;
       [chans, iorig] = intersect(currentChannelsInOriginal, detrendChannels);
       isort = sort(iorig);
       detrend.detrendChannels = isort(:)';
       EEGNew = removeTrend(EEGReporting, detrend);
    else
       EEGNew = EEGReporting;
    end
    [fref, sref, badSpectraChannels] = showSpectrum(EEGNew, channelLabels, ...
        actualLineChannels, actualLineChannels, tString, 20);
    clear EEGNew;
    if ~isempty(badSpectraChannels)
        badString = ['Channels with no spectra: ' getListString(badSpectraChannels)];
        fprintf(consoleFID, '%s\n', badString);
        writeHtmlList(summaryFile, {badString}, 'both');
    end
end

%% Referencing step
writeSummaryHeader(summaryFile,  'Reference summary', 'h4');
summary = reportReference(consoleFID, reference, numbersPerRow, indent);
writeHtmlList(summaryFile, summary, 'both');

%% Robust channel deviation (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping robust channel deviation\n');
else
    noisyStatistics = reference.noisyStatistics;
    showColorbar = true;   
    channelInformation = reference.channelInformation;
    nosedir = channelInformation.nosedir;
    channelLocations = reference.channelLocations;
   
    [referencedLocations, evaluationChannels, noiseLegendString]= ...
        getReportChannelInformation(channelLocations, ...
        noisyStatistics.evaluationChannels, noisyStatistics.noisyChannels);
    

    interpolatedLocations = getReportChannelInformation(channelLocations, ...
        noisyStatistics.evaluationChannels, reference.badChannels);
    % Original locations
    if ~isfield(reference, 'noisyStatisticsOriginal') || ...
            isempty(reference.noisyStatisticsOriginal)
        noisyStatisticsOriginal = noisyStatistics;
        fprintf(consoleFID, 'No original statistics --- using final for both\n');
    else
        noisyStatisticsOriginal = reference.noisyStatisticsOriginal;
    end
    % Original locations
    if ~isfield(reference, 'noisyStatisticsBeforeInterpolation') || ...
            isempty(reference.noisyStatisticsBeforeInterpolation)
        noisyStatisticsBeforeInterpolation = noisyStatisticsOriginal;
        fprintf(consoleFID, ...
            'No statistics before interpolation --- using original for both\n');
    else
        noisyStatisticsBeforeInterpolation  = ...
                             reference.noisyStatisticsBeforeInterpolation;
    end
    originalLocations = getReportChannelInformation(channelLocations, ...
        noisyStatistics.evaluationChannels, noisyStatisticsOriginal.noisyChannels);
    numberEvaluationChannels = length(evaluationChannels);
    
    tString = 'Robust channel deviation';
    dataReferenced = noisyStatistics.robustChannelDeviation;
    dataReferenced = dataReferenced(evaluationChannels);
    dataOriginal = noisyStatisticsOriginal.robustChannelDeviation;
    dataOriginal = dataOriginal(evaluationChannels);
    dataBeforeInterpolation = ...
        noisyStatisticsBeforeInterpolation.robustChannelDeviation;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    medRef = noisyStatistics.channelDeviationMedian;
    sdnRef = noisyStatistics.channelDeviationSD;

    medOrig = noisyStatisticsOriginal.channelDeviationMedian;
    sdnOrig = noisyStatisticsOriginal.channelDeviationSD;
    
    medInterp = noisyStatisticsBeforeInterpolation.channelDeviationMedian;
    sdnInterp = noisyStatisticsBeforeInterpolation.channelDeviationSD;
    
    scale = max(max(abs(dataOriginal)), max(max(abs(dataBeforeInterpolation)), ...
                max(abs(dataReferenced))));
    clim = [-scale, scale];    
    fprintf(consoleFID, '\nNoisy channel legend: ');
    for j = 1:length(noiseLegendString)
        fprintf(consoleFID, '%s\n', noiseLegendString{j});
    end
    fprintf(consoleFID, '\n\n');
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end 

%% Robust channel deviation (original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping robust channel deviation (original)\n');
else
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end

%% Robust channel deviation (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping robust channel deviation (marking interpolated)\n');
else
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end  

%% Robust deviation window statistics
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping robust deviation window statistics\n');
else
    beforeDeviationLevels = noisyStatisticsOriginal.channelDeviations(evaluationChannels, :);
    afterDeviationLevels = noisyStatistics.channelDeviations(evaluationChannels, :);
    interpDeviationLevels = ...
        noisyStatisticsBeforeInterpolation.channelDeviations(evaluationChannels, :);
    beforeDeviation = (beforeDeviationLevels - medOrig)./sdnOrig;
    afterDeviation = (afterDeviationLevels - medRef)./sdnRef;
    interpDeviation = (interpDeviationLevels - medInterp)./sdnInterp;
    medianDeviationsOrig = median(beforeDeviationLevels(:));
    sdDeviationsOrig = mad(beforeDeviationLevels(:), 1)*1.4826;
    medianDeviationsRef = median(afterDeviationLevels(:));
    sdDeviationsRef = mad(afterDeviationLevels(:), 1)*1.4826;   
    medianDeviationsInterp = median(interpDeviationLevels(:));
    sdDeviationsInterp = mad(interpDeviationLevels(:), 1)*1.4826;
    thresholdName = 'Deviation score';
    theTitle = {char(noiseDetection.name); char([ thresholdName ' distribution'])};
    showCumulativeDistributions({beforeDeviation(:), interpDeviation(:), afterDeviation(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [-5, 5]);
    beforeDeviationCounts = ...
        sum(beforeDeviation >= noisyStatisticsOriginal.robustDeviationThreshold);
    afterDeviationCounts = ...
        sum(afterDeviation >= noisyStatistics.robustDeviationThreshold);
    interpDeviationCounts = ...
        sum(interpDeviation >= noisyStatisticsBeforeInterpolation.robustDeviationThreshold);
    beforeTimeScale = (0:length(beforeDeviationCounts)-1)*noisyStatisticsOriginal.correlationWindowSeconds;
    afterTimeScale = (0:length(afterDeviationCounts)-1)*noisyStatistics.correlationWindowSeconds;
    interpTimeScale = (0:length(interpDeviationCounts)-1)* ...
        noisyStatisticsBeforeInterpolation.correlationWindowSeconds;
    fractionBefore = mean(beforeDeviationCounts)/numberEvaluationChannels;
    fractionAfter = mean(afterDeviationCounts)/numberEvaluationChannels;
    fractionInterp = mean(interpDeviationCounts)/numberEvaluationChannels;
    counts = {beforeDeviationCounts, interpDeviationCounts, afterDeviationCounts};
    timeScales = {beforeTimeScale, interpTimeScale, afterTimeScale};
    showBadWindows(counts, timeScales, colors, symbols, ...
        numberEvaluationChannels, legendStrings, noiseDetection.name, thresholdName);
    reports = cell(19, 1);
    reports{1} = ['Deviation window statistics (over ' ...
        num2str(size(noisyStatistics.channelDeviations, 2)) ' windows)'];
    reports{2} = 'Large deviation channel fraction:';
    reports{3} = [indent ' [before=', ...
        num2str(fractionBefore) ', after=' num2str(fractionAfter) ']'];
    reports{4} = ['Median channel deviation: [before=', ...
        num2str(noisyStatisticsOriginal.channelDeviationMedian) ...
        ', after=' num2str(noisyStatistics.channelDeviationMedian) ']'];
    reports{5} = ['SD channel deviation: [before=', ...
        num2str(noisyStatisticsOriginal.channelDeviationSD) ...
        ', after=' num2str(noisyStatistics.channelDeviationSD) ']'];
    reports{6} = ['Max raw deviation level [before=', ...
        num2str(max(beforeDeviationLevels(:))) ', after=' ...
        num2str(max(afterDeviationLevels(:))) ']'];
    reports{7} = ['Average fraction ' num2str(fractionBefore) ...
               ' (' num2str(mean(beforeDeviationCounts)) ' channels)']; 
    reports{8}= [indent ' not meeting threshold before in each window'];
    reports{9} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterDeviationCounts)) ' channels)'];
    reports{10} = [ indent ' not meeting threshold after in each window'];
    quarterChannels = round(length(evaluationChannels)*0.25);
    halfChannels = round(length(evaluationChannels)*0.5);
    reports{11} = 'Windows with > 1/4 deviation channels:';
    reports{12} = [indent '[before=' ...
           num2str(sum(beforeDeviationCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterDeviationCounts > quarterChannels)) ']'];
    reports{13} = 'Windows with > 1/2 deviation channels:';
    reports{14} = [indent '[before=', ...
        num2str(sum(beforeDeviationCounts > halfChannels)) ...
        ', after=' num2str(sum(afterDeviationCounts > halfChannels))  ']'];
    reports{15} = ['Median window deviations: [before=', ...
              num2str(medianDeviationsOrig) ', after=' num2str(medianDeviationsRef) ']'];
    reports{16} = ['SD window deviations: [before=', ...
        num2str(sdDeviationsOrig) ', after=' num2str(sdDeviationsRef) ']'];
    if isfield(noisyStatistics, 'dropOuts')
        drops = sum(noisyStatistics.dropOuts, 2)';
        indexDrops = find(drops > 0);
        dropList = [indexDrops; drops(indexDrops)];
        if ~isempty(indexDrops) > 0
            reportString = sprintf('%g[%g drops] ', dropList(:)');
        else
            reportString = 'None';
        end
        reports{17} = ['Channels with dropouts: ' reportString];
    end
    fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryHeader(summaryFile,  'Deviation statistics summary', 'h4');
    writeHtmlList(summaryFile, {reports{1}, reports{2}, reports{3}}, 'both');
end    

%% Median max abs correlation (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping median max absoluted correlation (referenced)\n');
else
    tString = 'Median max correlation';
    dataReferenced = noisyStatistics.medianMaxCorrelation;
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end 

%% Median max abs correlation (original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping median max abs correlation (original)\n');
else
    tString = 'Median max correlation';
    dataOriginal = noisyStatisticsOriginal.medianMaxCorrelation;
    dataOriginal = dataOriginal(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end 

%% Median max abs correlation (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, ...
        'Skipping median max abs correlation (marking interpolated)\n');
else
    tString = 'Median max correlation';
    dataBeforeInterpolation = ...
        noisyStatisticsBeforeInterpolation.medianMaxCorrelation;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end 

%% Mean max abs correlation (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, ...
        'Skipping median max abs correlation (referenced)\n');
else
    tString = 'Mean max correlation';
    dataReferenced = mean(noisyStatistics.maximumCorrelations, 2);
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end

%% Mean max abs correlation (original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping mean max abs correlation (original)\n');
else
    tString = 'Mean max correlation';
    dataOriginal = mean(noisyStatisticsOriginal.maximumCorrelations, 2);
    dataOriginal = dataOriginal(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end  

%% Mean max abs correlation (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, ...
        'Skipping mean max abs correlation (marking interpolated)\n');
else
    tString = 'Mean max correlation';
    dataBeforeInterpolation = ...
        mean(noisyStatisticsBeforeInterpolation.maximumCorrelations, 2); 
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end 

%% Bad min max correlation fraction (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping bad min max correlation (referenced)\n');
else
    tString = 'Min max corr fraction';
    thresholdedCorrelations = noisyStatistics.maximumCorrelations ...
               < noisyStatistics.correlationThreshold;
    dataReferenced = mean(thresholdedCorrelations, 2);
    dataReferenced = dataReferenced(evaluationChannels);
    thresholdedCorrelations = noisyStatisticsOriginal.maximumCorrelations ...
               < noisyStatisticsOriginal.correlationThreshold;
    dataOriginal = mean(thresholdedCorrelations, 2);
    dataOriginal = dataOriginal(evaluationChannels);
    thresholdedCorrelations = noisyStatisticsBeforeInterpolation.maximumCorrelations ...
               < noisyStatisticsBeforeInterpolation.correlationThreshold;
    dataBeforeInterpolation = mean(thresholdedCorrelations, 2);
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    scale = max(max(max(max(dataReferenced), max(dataOriginal)), ...
                max(dataBeforeInterpolation)), reference.badTimeThreshold);
    clim = [0, 2*reference.badTimeThreshold]; 
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(referenced)'])
end    
%% Bad min max correlation fraction(original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping median max abs correlation (original)\n');
else
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(original)'])
end

%% Bad min max correlation fraction (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, ...
        'Skipping bad min max correlation fraction (marking interpolated)\n');
else
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(marking interpolated)'])
end  

%% Correlation window statistics
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping correlation window statistics\n');
else
    beforeCorrelationLevels = ...
        noisyStatisticsOriginal.maximumCorrelations(evaluationChannels, :);
    afterCorrelationLevels = ...
        noisyStatistics.maximumCorrelations(evaluationChannels, :);
    interpCorrelationLevels = ...
        noisyStatisticsBeforeInterpolation.maximumCorrelations(evaluationChannels, :);
    thresholdName = 'Maximum correlation';
    theTitle = {char(noiseDetection.name); char([thresholdName ' distribution'])};
    showCumulativeDistributions( ...
        {beforeCorrelationLevels(:),interpCorrelationLevels(:), afterCorrelationLevels(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [0, 1]);
    beforeCorrelationCounts = sum(beforeCorrelationLevels <= ...
        noisyStatisticsOriginal.correlationThreshold);
    afterCorrelationCounts = sum(afterCorrelationLevels <= ...
        noisyStatistics.correlationThreshold);
    interpCorrelationCounts = sum(interpCorrelationLevels <= ...
        noisyStatisticsBeforeInterpolation.correlationThreshold);
    beforeTimeScale = (0:length(beforeCorrelationCounts)-1)* ...
        noisyStatisticsOriginal.correlationWindowSeconds;
    afterTimeScale = (0:length(afterCorrelationCounts)-1)* ...
        noisyStatistics.correlationWindowSeconds;
    interpTimeScale = (0:length(interpCorrelationCounts)-1)* ...
        noisyStatisticsBeforeInterpolation.correlationWindowSeconds;
    counts = {beforeCorrelationCounts, interpCorrelationCounts, afterCorrelationCounts};
    timeScales = {beforeTimeScale, interpTimeScale, afterTimeScale};
    showBadWindows(counts, timeScales, colors, symbols, ...
        numberEvaluationChannels, legendStrings, noiseDetection.name, thresholdName);
    fractionBefore = mean(beforeCorrelationCounts)/numberEvaluationChannels;
    fractionAfter = mean(afterCorrelationCounts)/numberEvaluationChannels;
    reports = cell(10, 1);
    reports{1} = ['Max correlation window statistics (over ' ...
        num2str(size(noisyStatistics.maximumCorrelations, 2)) ' windows)'];
    reports{2} = ['Overall median maximum correlation [before=', ...
        num2str(median(noisyStatisticsOriginal.medianMaxCorrelation(:))) ...
        ', after=' num2str(median(noisyStatistics.medianMaxCorrelation(:))) ']'];
    reports{3} = ['Low max correlation fraction [before=', ...
        num2str(fractionBefore) ', after=' num2str(fractionAfter) ']'];
    reports{4} = ['Minimum max correlation level [before=', ...
        num2str(min(beforeCorrelationLevels(:))) ', after=' ...
        num2str(min(afterCorrelationLevels(:))) ']'];
    reports{5} = ['Average fraction ' num2str(fractionBefore) ...
               ' (' num2str(mean(beforeCorrelationCounts)) ' channels):']; 
    reports{6} =  [indent ' not meeting threshold before in each window'];
    reports{7} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterCorrelationCounts)) ' channels):'];
    reports{8} = [indent ' not meeting threshold after in each window'];
    quarterChannels = round(length(evaluationChannels)*0.25);
    halfChannels = round(length(evaluationChannels)*0.5);
    reports{9} = ['Windows with > 1/4 bad channels: [before=', ...
        num2str(sum(beforeCorrelationCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterCorrelationCounts > quarterChannels)) ']'];
    reports{10} = ['Windows with > 1/2 bad channels: [before=', ...
        num2str(sum(beforeCorrelationCounts > halfChannels)) ...
        ', after=' num2str(sum(afterCorrelationCounts > halfChannels)) ']'];
    fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryHeader(summaryFile,  'Correlation statistics summary', 'h4');
    writeHtmlList(summaryFile, {reports{1}, reports{2}}, 'both');
end

%% Bad ransac fraction (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping bad ransac fraction (referenced)\n');
else
    tString = 'Ransac fraction failed';
    dataReferenced = noisyStatistics.ransacBadWindowFraction;
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];    
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(referenced)'])
end    

%% Bad ransac fraction (original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping bad ransac fraction (original)\n');
else
    dataOriginal = noisyStatisticsOriginal.ransacBadWindowFraction;
    dataOriginal = dataOriginal(evaluationChannels);
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(original)'])
end

%% Bad ransac fraction (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping bad ransac fraction (marking interpolated)\n');
else
    dataBeforeInterpolation = noisyStatisticsBeforeInterpolation.ransacBadWindowFraction;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(marking interpolated)'])
end  

%% Channels with poor ransac correlations
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping channels with poor ransac correlations\n');
else
    beforeRansacLevels = ...
        noisyStatisticsOriginal.ransacCorrelations(evaluationChannels, :);
    afterRansacLevels = ...
        noisyStatistics.ransacCorrelations(evaluationChannels, :);
    interpRansacLevels = ...
        noisyStatisticsBeforeInterpolation.ransacCorrelations(evaluationChannels, :);
    thresholdName = 'Ransac correlation';
    theTitle = {char([noiseDetection.name ': ' thresholdName ' distribution'])};
    showCumulativeDistributions({beforeRansacLevels(:), ...
        interpRansacLevels(:), afterRansacLevels(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [0, 1]);
    
    beforeRansacCounts = sum(beforeRansacLevels <= ...
        noisyStatisticsOriginal.ransacCorrelationThreshold);
    afterRansacCounts = sum(afterRansacLevels <= ...
        noisyStatistics.ransacCorrelationThreshold);
    interpRansacCounts = sum(interpRansacLevels <= ...
        noisyStatisticsBeforeInterpolation.ransacCorrelationThreshold);
    beforeTimeScale = (0:length(beforeRansacCounts)-1)* ...
        noisyStatisticsOriginal.ransacWindowSeconds;
    afterTimeScale = (0:length(afterRansacCounts)-1)* ...
        noisyStatistics.ransacWindowSeconds;
    interpTimeScale = (0:length(interpRansacCounts)-1)* ...
        noisyStatisticsBeforeInterpolation.ransacWindowSeconds;
    counts = {beforeRansacCounts, interpRansacCounts, afterRansacCounts};
    timeScales = {beforeTimeScale, interpTimeScale, afterTimeScale};
    showBadWindows(counts, timeScales, colors, symbols, ...
        numberEvaluationChannels, legendStrings, noiseDetection.name, thresholdName);

    fractionBefore = mean(beforeRansacCounts)/numberEvaluationChannels;
    fractionAfter = mean(afterRansacCounts)/numberEvaluationChannels;
    reports = cell(9, 0);
    reports{1} = ['Ransac window statistics (over ' ...
        num2str(size(afterRansacLevels, 2)) ' windows)'];
    reports{2} = ['Low ransac channel fraction [before=', ...
        num2str(fractionBefore) ', after=' num2str(fractionAfter) ']'];
    reports{3} = ['Minimum ransac correlation [before=', ...
        num2str(min(beforeRansacLevels(:))) ', after=' ...
        num2str(min(afterRansacLevels(:))) ']'];
    reports{4} = ['Average fraction ' num2str(fractionBefore) ...
               ' (' num2str(mean(beforeRansacCounts)) ' channels):'];
    reports{5} = [indent ' not meeting threshold before in each window'];
    reports{6} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterRansacCounts)) ' channels):'];
    reports{7} = [indent ' not meeting threshold after in each window'];
    quarterChannels = round(length(evaluationChannels)*0.25);
    halfChannels = round(length(evaluationChannels)*0.5);
    reports{8} = ['Windows with > 1/4 bad ransac channels: [before=', ...
        num2str(sum(beforeRansacCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterRansacCounts > quarterChannels)) ']'];
    reports{9} = ['Windows with > 1/2 bad ransac channels: [before=', ...
        num2str(sum(beforeRansacCounts > halfChannels)) ...
        ', after=' num2str(sum(afterRansacCounts > halfChannels)) ']'];
    fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryHeader(summaryFile,  'Ransac statistics summary', 'h4');
    writeHtmlList(summaryFile, {reports{1}, reports{2}}, 'both');
end    
%% HF noise Z-score (referenced)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping HF noise Z-score (referenced)\n');
else
    tString = 'Z-score HF SNR';
    dataReferenced = noisyStatistics.zscoreHFNoise;
    dataReferenced = dataReferenced(evaluationChannels);
    dataOriginal = noisyStatisticsOriginal.zscoreHFNoise;
    dataOriginal = dataOriginal(evaluationChannels);
    dataBeforeInterpolation = noisyStatisticsBeforeInterpolation.zscoreHFNoise;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    medRef = noisyStatistics.noisinessMedian;
    sdnRef = noisyStatistics.noisinessSD;
    medOrig = noisyStatisticsOriginal.noisinessMedian;
    sdnOrig = noisyStatisticsOriginal.noisinessSD;
    scale = max(max(abs(dataOriginal)), max(max(abs(dataReferenced)), ...
                max(abs(dataBeforeInterpolation))));
    % scale = max(max(abs(dataOriginal), abs(dataReferenced)));
    clim = [-scale, scale];  
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end  


%% HF noise Z-score (original)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping HF noise Z-score (original)\n');
else
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end

%% HF noise Z-score (interpolated)
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping HF noise Z-score (marking interpolated)\n');
else
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end

%% HF noise window stats
if isempty(reference) || ~fullInformation
    fprintf(consoleFID, 'Skipping HF window stats\n');
else
    beforeNoiseLevels = noisyStatisticsOriginal.noiseLevels(evaluationChannels, :);
    afterNoiseLevels = noisyStatistics.noiseLevels(evaluationChannels, :);
    interpNoiseLevels = ...
        noisyStatisticsBeforeInterpolation.noiseLevels(evaluationChannels, :);
    medianNoiseOrig = median(beforeNoiseLevels(:));
    sdNoiseOrig = mad(beforeNoiseLevels(:), 1)*1.4826;
    medianNoiseRef = median(afterNoiseLevels(:));
    sdNoiseRef = mad(afterNoiseLevels(:), 1)*1.4826;
    medianNoiseInterp = median(interpNoiseLevels(:));
    sdNoiseInterp = mad(interpNoiseLevels(:), 1)*1.4826;
    beforeNoise = (beforeNoiseLevels - medianNoiseOrig)./sdNoiseOrig;
    afterNoise = (afterNoiseLevels - medianNoiseRef)./sdNoiseRef;
    interpNoise = (interpNoiseLevels - medianNoiseInterp)./sdNoiseInterp;
    thresholdName = 'HF noise';
    theTitle = {char(noiseDetection.name); [thresholdName ' HF noise distribution']};
    showCumulativeDistributions({beforeNoise(:), interpNoise(:), afterNoise(:)},  ...
        thresholdName, colors, theTitle, legendStrings, [-5, 5]);
    beforeNoiseCounts = sum(beforeNoise  >= ...
        noisyStatisticsOriginal.highFrequencyNoiseThreshold);
    afterNoiseCounts = sum(afterNoise >= ...
        noisyStatistics.highFrequencyNoiseThreshold);
    interpNoiseCounts = sum(interpNoise >= ...
        noisyStatisticsBeforeInterpolation.highFrequencyNoiseThreshold);
    beforeTimeScale = (0:length(beforeNoiseCounts)-1)* ...
        noisyStatisticsOriginal.correlationWindowSeconds;
    afterTimeScale = (0:length(afterNoiseCounts)-1)* ...
        noisyStatistics.correlationWindowSeconds;
    interpTimeScale = (0:length(interpNoiseCounts)-1)* ...
        noisyStatisticsBeforeInterpolation.correlationWindowSeconds;
    counts = {beforeNoiseCounts, interpNoiseCounts, afterNoiseCounts};
    timeScales = {beforeTimeScale, interpTimeScale, afterTimeScale};
    showBadWindows(counts, timeScales, colors, symbols, ...
        numberEvaluationChannels, legendStrings, noiseDetection.name, thresholdName);
 
    fractionBefore = mean(beforeNoiseCounts)/numberEvaluationChannels;
    fractionAfter = mean(afterNoiseCounts)/numberEvaluationChannels;
    reports = cell(17,0);
    reports{1} = ['Noise window statistics (over ' ...
        num2str(size(noisyStatistics.noiseLevels, 2)) ' windows)'];
    reports{2} = 'Channel fraction with HF noise:';
    reports{3} = [indent '[before=', ...
                  num2str(fractionBefore) ', after=' num2str(fractionAfter) ']'];
    reports{4} = ['Median noisiness: [before=', ...
        num2str(noisyStatisticsOriginal.noisinessMedian) ...
        ', after=' num2str(noisyStatistics.noisinessMedian) ']'];
    reports{5} = ['SD noisiness: [before=', ...
        num2str(noisyStatisticsOriginal.noisinessSD) ...
        ', after=' num2str(noisyStatistics.noisinessSD) ']'];
    reports{6} = ['Max HF noise levels [before=', ...
        num2str(max(beforeNoiseLevels(:))) ', after=' ...
        num2str(max(afterNoiseLevels(:))) ']'];
    reports{7} = ['Average fraction ' num2str(fractionBefore) ...
                ' (' num2str(mean(beforeNoiseCounts)) ' channels):'];
    reports{8} = [indent ' not meeting threshold before in each window'];
    reports{9} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterNoiseCounts)) ' channels):'];
    reports{10} = [indent ' not meeting threshold after in each window'];
    reports{11} = [indent ' not meeting threshold after relative to before in each window'];
    quarterChannels = round(length(evaluationChannels)*0.25);
    halfChannels = round(length(evaluationChannels)*0.5);
    reports{12} = 'Windows with > 1/4 HF channels:';
    reports{13} = [indent '[before=', ...
        num2str(sum(beforeNoiseCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterNoiseCounts > quarterChannels)) ']'];
    reports{14} = 'Windows with > 1/2 HF channels:';
    reports{15} = [indent '[before=', ...
        num2str(sum(beforeNoiseCounts > halfChannels)) ...
        ', after=' num2str(sum(afterNoiseCounts > halfChannels)) ']'];
    reports{16} = ['Median window HF: [before=', ...
        num2str(medianNoiseOrig) ', after=' num2str(medianNoiseRef) ']'];
    reports{17} = ['SD window HF: [before=', ...
        num2str(sdNoiseOrig) ', after=' num2str(sdNoiseRef) ']'];
     fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryHeader(summaryFile,  'HF statistics summary', 'h4');
    writeHtmlList(summaryFile, {reports{1}, reports{2}, reports{3}}, 'both');
end


%% Noisy average vs robust average reference
if isempty(reference) || ~fullInformation || ...
    ~isfield(reference, 'referenceSignal') || isempty(reference.referenceSignal)
    fprintf(consoleFID, 'Skipping noisy vs robust average reference\n');
else
    corrAverage = corr(reference.referenceSignal(:), ...
               reference.referenceSignalOriginal(:));
    tString = { noiseDetection.name, ...
        ['Comparison of reference signals (corr=' num2str(corrAverage) ')']};
    figure('Name', tString{2})
    plot(reference.referenceSignal, reference.referenceSignalOriginal, '.k');
    xlabel('Robust average reference')
    ylabel('Ordinary average reference');
    title(tString, 'Interpreter', 'None');
    corrString = ['Ordinary vs robust average reference (unfiltered) correlation: ' ...
        num2str(corrAverage)];
    writeSummaryHeader(summaryFile,  corrString, 'h4');
end   

%% Noisy and robust average reference by time
if isempty(reference) || ~fullInformation || ...
    ~isfield(reference, 'referenceSignal') || isempty(reference.referenceSignal)
    fprintf(consoleFID, 'Skipping noisy and robust average reference by time\n');
else
    tString = { noiseDetection.name, 'ordinary - robust average reference signals'};
    t = (0:length(reference.referenceSignal) - 1)/EEGReporting.srate;
    figure('Name', tString{2})
    plot(t, reference.referenceSignalOriginal - reference.referenceSignal, '.k');
    xlabel('Seconds')
    ylabel('Original - robust');
    title(tString, 'Interpreter', 'None');
end

%% Noisy vs robust average reference (filtered)
if isempty(reference) || ~fullInformation || ...
    ~isfield(reference, 'referenceSignal') || isempty(reference.referenceSignal)
    fprintf(consoleFID, 'Skipping noisy vs robust average reference (filtered)\n');
else
    EEGTemp = eeg_emptyset();
    EEGTemp.nbchan = 2;
    a = reference.referenceSignal;
    b = reference.referenceSignalOriginal;
    EEGTemp.pnts = length(a);
    EEGTemp.data = [a(:)'; b(:)'];
    EEGTemp.srate = EEGReporting.srate;
    EEGTemp = pop_eegfiltnew(EEGTemp, noiseDetection.detrend.detrendCutoff, []);
    corrAverage = corr(EEGTemp.data(1, :)', EEGTemp.data(2, :)');
    tString = { noiseDetection.name, ...
        ['Comparison of reference signals (corr=' num2str(corrAverage) ')']};
    figure('Name', tString{2})
    plot(EEGTemp.data(1, :),  EEGTemp.data(2, :), '.k');
    xlabel('Robust average reference')
    ylabel('Ordinary average reference');
    title(tString, 'Interpreter', 'None');
    corrString = ['Ordinary vs robust average reference (filtered) correlation: ' ...
        num2str(corrAverage)];
    writeSummaryHeader(summaryFile,  corrString, 'h4');
end
%% Noisy minus robust average reference by time
if isempty(reference) || ~fullInformation || ...
    ~isfield(reference, 'referenceSignal') || isempty(reference.referenceSignal)
    fprintf(consoleFID, 'Skipping noisy minus robust average reference by time\n');
else
    tString = { noiseDetection.name, 'ordinary - robust average reference signals'};
    t = (0:length(EEGTemp.data(2, :)) - 1)/EEGReporting.srate;
    figure('Name', tString{2})
    plot(t, EEGTemp.data(2, :) - EEGTemp.data(1, :), '.k');
    xlabel('Seconds')
    ylabel('Average - robust');
    title(tString, 'Interpreter', 'None');
end
clear EEGReporting summaryFile consoleFID relativeReportLocation;