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
noiseDetection = EEGReporting.etc.noiseDetection;
if isfield(noiseDetection, 'reference')
    reference = noiseDetection.reference;
else
    reference = struct();
end
summaryHeader = [noiseDetection.name '[' ...
    num2str(size(EEGReporting.data, 1)) ' channels, ' num2str(size(EEGReporting.data, 2)) ' frames]'];
fprintf(consoleFID, '%s\n', summaryHeader);
summaryHeader = [summaryHeader ' <a href="' relativeReportLocation ...
    '">Report details</a>'];
writeSummaryHeader(summaryFile,  summaryHeader);

%  Write overview status
errorStatus = getErrors(noiseDetection);
writeHtmlList(summaryFile, errorStatus, 'first');
writeTextList(consoleFID, errorStatus);

% Versions
versions = EEGReporting.etc.noiseDetection.version;
versionString = getStructureString(EEGReporting.etc.noiseDetection.version);
writeHtmlList(summaryFile, {['Versions: ' versionString]});
fprintf(consoleFID, 'Versions:\n%s\n', versionString);

% Events
srateMsg = {'Sampling rate: ' num2str(EEGReporting.srate) 'Hz'};
writeHtmlList(summaryFile, srateMsg);
writeTextList(consoleFID, srateMsg);

[summary, hardFrames] = reportEvents(consoleFID, EEGReporting);
writeHtmlList(summaryFile, summary);

% Interpolated channels for referencing
if isfield(noiseDetection, 'reference')
    interpolatedChannels = getFieldIfExists(noiseDetection, ...
        'interpolatedChannels');
    summaryItem = ['Bad channels interpolated for reference: [' ...
                    num2str(interpolatedChannels), ']'];
    writeHtmlList(summaryFile, {summaryItem});
    fprintf(consoleFID, '%s\n', summaryItem);
end
% Setup visualization parameters
numbersPerRow = 10;
indent = '  ';
%colorsNew = [0, 0, 0; 0.8, 0.8, 0.8; 1, 0, 0];
colors = [0, 0, 0; 0, 1, 0; 1, 0, 0];
legendStrings = {'Original', 'Before interp' 'Final'};
symbols = {'+', 'x', 'o'};
%colors = [0, 0, 0; 1, 0, 0; 0, 1, 0];
%legendStrings = {'Original', 'Final'};
scalpMapInterpolation = 'v4';
darkElementColor = [0.5, 0.5, 0.5];
headColor = [0.95, 0.95, 0.95];
elementColor = [0, 0, 0];
%% Line noise removal step
summary = reportLineNoise(consoleFID, noiseDetection, numbersPerRow, indent);
writeHtmlList(summaryFile, summary);

%% Initial detrend for reference calculation
summary = reportDetrend(consoleFID, noiseDetection, numbersPerRow, indent);
writeHtmlList(summaryFile, summary);

%% Spectrum after line noise and detrend
if isfield(noiseDetection, 'lineNoise')
    lineChannels = noiseDetection.lineNoise.lineNoiseChannels; 
    numChans = min(6, length(lineChannels));
    indexchans = floor(linspace(1, length(lineChannels), numChans));
    displayChannels = lineChannels(indexchans);
    channelLabels = {EEGReporting.chanlocs(lineChannels).labels};
    tString = noiseDetection.name;
    if isfield(noiseDetection, 'detrend') 
       EEGNew = removeTrend(EEGReporting, noiseDetection.detrend);
    else
       EEGNew = EEGReporting;
    end
    [fref, sref, badChannels] = showSpectrum(EEGNew, channelLabels, ...
        lineChannels, displayChannels, tString);
    clear EEGNew;
    if ~isempty(badChannels)
        badString = ['Channels with no spectra: ' getListString(badChannels)];
        fprintf(consoleFID, '%s\n', badString);
        writeHtmlList(summaryFile, {badString});
    end
end


%% Report referencing step
if isfield(noiseDetection, 'reference') && ~isempty(noiseDetection.reference) 
   [summary, noisyStatistics] = reportReference(consoleFID,  ...
                                  noiseDetection, numbersPerRow, indent);
    writeHtmlList(summaryFile, summary);
   EEGReporting.etc.noiseDetection.reference.noisyStatistics = noisyStatistics;
end
%% Robust channel deviation (referenced)
if isfield(noiseDetection, 'reference') && ~isempty(noiseDetection.reference) 
    reference = noiseDetection.reference;
    noisyStatistics = reference.noisyStatistics;

    showColorbar = true;   
    channelInformation = reference.channelInformation;
    nosedir = channelInformation.nosedir;
    channelLocations = reference.channelLocations;
   
    [referencedLocations, evaluationChannels, noiseLegendString]= ...
        getReportChannelInformation(channelLocations, ...
        noisyStatistics.evaluationChannels, noisyStatistics.noisyChannels);
    

    interpolatedLocations = getReportChannelInformation(channelLocations, ...
        noisyStatistics.evaluationChannels, reference.interpolatedChannels);
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
    %scale = max(max(abs(dataOriginal), abs(dataReferenced)));
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
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end

%% Robust channel deviation (marking interpolated)
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end  



%% Robust deviation window statistics
if isfield(noiseDetection, 'reference')
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
    writeHtmlList(summaryFile, {reports{1}, reports{2}, reports{3}});
end    

%% Median max abs correlation (referenced)
if isfield(noiseDetection, 'reference')
    tString = 'Median max correlation';
    dataReferenced = noisyStatistics.medianMaxCorrelation;
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end 

%% Median max abs correlation (original)
if isfield(noiseDetection, 'reference')
    tString = 'Median max correlation';
    dataOriginal = noisyStatisticsOriginal.medianMaxCorrelation;
    dataOriginal = dataOriginal(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end 

%% Median max abs correlation (marking interpolated)
if isfield(noiseDetection, 'reference')
    tString = 'Median max correlation';
    dataBeforeInterpolation = ...
        noisyStatisticsBeforeInterpolation.medianMaxCorrelation;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end 



%% Mean max abs correlation (referenced)
if isfield(noiseDetection, 'reference')
    tString = 'Mean max correlation';
    dataReferenced = mean(noisyStatistics.maximumCorrelations, 2);
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end

%% Mean max abs correlation (original)
if isfield(noiseDetection, 'reference')
    tString = 'Mean max correlation';
    dataOriginal = mean(noisyStatisticsOriginal.maximumCorrelations, 2);
    dataOriginal = dataOriginal(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end  

%% Mean max abs correlation (marking interpolated)
if isfield(noiseDetection, 'reference')
    tString = 'Mean max correlation';
    dataBeforeInterpolation = ...
        mean(noisyStatisticsBeforeInterpolation.maximumCorrelations, 2); 
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    clim = [0, 1];
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end 

%% Bad min max correlation fraction (referenced)
if isfield(noiseDetection, 'reference')
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
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(original)'])
end

%% Bad min max correlation fraction (marking interpolated)
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(marking interpolated)'])
end  

%% Correlation window statistics
if isfield(noiseDetection, 'reference')
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
    writeHtmlList(summaryFile, {reports{1}, reports{2}});
end

%% Bad ransac fraction (referenced)
if isfield(noiseDetection, 'reference')
    tString = 'Ransac fraction failed';
    dataReferenced = noisyStatistics.ransacBadWindowFraction;
    dataReferenced = dataReferenced(evaluationChannels);
    clim = [0, 1];    
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(referenced)'])
end    

%% Bad ransac fraction (original)
if isfield(noiseDetection, 'reference')
    dataOriginal = noisyStatisticsOriginal.ransacBadWindowFraction;
    dataOriginal = dataOriginal(evaluationChannels);
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(original)'])
end

%% Bad ransac fraction (marking interpolated)
if isfield(noiseDetection, 'reference')
    dataBeforeInterpolation = noisyStatisticsBeforeInterpolation.ransacBadWindowFraction;
    dataBeforeInterpolation = dataBeforeInterpolation(evaluationChannels);
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, darkElementColor, clim, nosedir, [tString '(marking interpolated)'])
end  
%% Channels with poor ransac correlations
if isfield(noiseDetection, 'reference')
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
    writeHtmlList(summaryFile, {reports{1}, reports{2}});
end    
%% HF noise Z-score (referenced)
if isfield(noiseDetection, 'reference')
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
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end

%% HF noise Z-score (marking interpolated)
if isfield(noiseDetection, 'reference')
    plotScalpMap(dataBeforeInterpolation, interpolatedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(marking interpolated)'])
end
%% HF noise window stats
if isfield(noiseDetection, 'reference')
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
    writeHtmlList(summaryFile, {reports{1}, reports{2}, reports{3}});
end


%% Noisy average reference vs robust average reference
if isfield(noiseDetection, 'reference') && ...
        isfield(reference, 'referenceSignal') && ...
        ~isempty(reference.referenceSignal)
    corrAverage = corr(reference.referenceSignal(:), ...
               reference.referenceSignalOriginal(:));
    tString = { noiseDetection.name, ...
        ['Comparison of reference signals (corr=' num2str(corrAverage) ')']};
    figure('Name', tString{2})
    plot(reference.referenceSignal, reference.referenceSignalOriginal, '.k');
    xlabel('Robust average reference')
    ylabel('Ordinary average reference');
    title(tString, 'Interpreter', 'None');
    writeHtmlList(summaryFile, ...
        {['Correlation between ordinary and robust average reference (unfiltered): ' ...
        num2str(corrAverage)]});
end   
%% Noisy average reference - robust average reference by time
if isfield(noiseDetection, 'reference') && ...
    isfield(reference, 'referenceSignal') && ...
     ~isempty(reference.referenceSignal)
    tString = { noiseDetection.name, 'ordinary - robust average reference signals'};
    t = (0:length(reference.referenceSignal) - 1)/EEGReporting.srate;
    figure('Name', tString{2})
    plot(t, reference.referenceSignalOriginal - reference.referenceSignal, '.k');
    xlabel('Seconds')
    ylabel('Original - robust');
    title(tString, 'Interpreter', 'None');
end

%% Noisy average reference vs robust average reference (filtered)
if isfield(noiseDetection, 'reference')
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
    writeHtmlList(summaryFile, ...
        {['Correlation between ordinary and robust average reference (filtered): ' ...
        num2str(corrAverage)]});
end
%% Noisy average reference - robust average reference by time
if isfield(noiseDetection, 'reference') 
    tString = { noiseDetection.name, 'ordinary - robust average reference signals'};
    t = (0:length(EEGTemp.data(2, :)) - 1)/EEGReporting.srate;
    figure('Name', tString{2})
    plot(t, EEGTemp.data(2, :) - EEGTemp.data(1, :), '.k');
    xlabel('Seconds')
    ylabel('Average - robust');
    title(tString, 'Interpreter', 'None');
end
clear EEGReporting summaryFile consoleFID relativeReportLocation;