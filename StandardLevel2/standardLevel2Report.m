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

%% Write data status and report header
noisyParameters = EEG.etc.noisyParameters;
summaryHeader = [noisyParameters.name '[' ...
    num2str(size(EEG.data, 1)) ' channels, ' num2str(size(EEG.data, 2)) ' frames]'];
summaryHeader = [summaryHeader ' <a href="' relativeReportLocation ...
    '">Report details</a>'];
writeSummaryHeader(summaryFile,  summaryHeader);

%  Write overview status
writeSummaryItem(summaryFile, '', 'first');
errorStatus = ['Error status: ' noisyParameters.errors.status];
fprintf(consoleFID, '%s \n', errorStatus);
writeSummaryItem(summaryFile, {errorStatus});

% Versions
versions = EEG.etc.noisyParameters.version;
versionString = [' Resampling:' versions.Resampling ...
                 ' High pass:' versions.HighPass ...
                 ' Line noise:' versions.LineNoise ...
                 ' Reference:' versions.Reference ...
                 ' Interpolate: ' versions.Interpolation];
writeSummaryItem(summaryFile, {['Versions: ' versionString]});
fprintf(consoleFID, 'Versions:\n%s\n', versionString);

% Events
[summary, hardFrames] = reportEvents(consoleFID, EEG);
writeSummaryItem(summaryFile, summary);

% Setup visualization parameters
numbersPerRow = 15;
indent = '  ';
colors = [0, 0, 0; 1, 0, 0; 0, 1, 0];
legendStrings = {'Before referencing', 'After referencing', 'After referencing (relative)'};

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
    displayChannels = lineChannels(indexchans);
    channelLabels = {EEG.chanlocs(lineChannels).labels};
    tString = noisyParameters.name;
    badChannels = showSpectrum(EEG, lineChannels, displayChannels, ...
                             channelLabels, tString);
    if ~isempty(badChannels)
        badString = ['Channels with no spectra: ' getListString(badChannels)];
        fprintf(consoleFID, '%s\n', badString);
        writeSummaryItem(summaryFile, {badString});
    end
end
%% Report referencing step 
summary = reportReferenced(consoleFID, noisyParameters, numbersPerRow, indent);
writeSummaryItem(summaryFile, summary);

%% Robust channel deviation (original)
if isfield(noisyParameters, 'reference')
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
    numberReferenceChannels = length(referenceChannels);
    tString = 'Robust channel deviation';
    dataOriginal = original.robustChannelDeviation;
    dataReferenced = referenced.robustChannelDeviation;
    medOrig = original.channelDeviationMedian;
    sdnOrig = original.channelDeviationSD;
    medRef = referenced.channelDeviationMedian;
    sdnRef = referenced.channelDeviationSD;
    dataReferencedRel = ((dataReferenced*sdnRef + medRef) - medOrig)/sdnOrig;
    scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
    clim = [-scale, scale];    
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end   
%% Robust channel deviation (referenced)
if isfield(noisyParameters, 'reference')
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end  
%% Robust channel deviation (referenced relative to original)
if isfield(noisyParameters, 'reference')  
    plotScalpMap(dataReferencedRel, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced rel)'])
end    
%% Robust deviation window statistics
if isfield(noisyParameters, 'reference')
    beforeDeviationLevels = original.channelDeviations(referenceChannels, :);
    afterDeviationLevels = referenced.channelDeviations(referenceChannels, :);
    beforeDeviation = (beforeDeviationLevels - medOrig)./sdnOrig;
    afterDeviation = (afterDeviationLevels - medRef)./sdnRef;
    afterDeviationRel = (afterDeviationLevels - medOrig)./sdnOrig;
    medianDeviationsOrig = median(beforeDeviationLevels(:));
    sdDeviationsOrig = mad(beforeDeviationLevels(:), 1)*1.4826;
    medianDeviationsRef = median(afterDeviationLevels(:));
    sdDeviationsRef = mad(afterDeviationLevels(:), 1)*1.4826;
    thresholdName = 'Deviation score';
    theTitle = {char(noisyParameters.name); char([ thresholdName ' distribution'])};
    showCumulativeDistributions({beforeDeviation(:), afterDeviation(:), ...
        afterDeviationRel(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [-5, 5]);
    beforeDeviationCounts = sum(beforeDeviation >= original.robustDeviationThreshold);
    afterDeviationCounts = sum(afterDeviation >= referenced.robustDeviationThreshold);
    afterDeviationRelCounts = sum(afterDeviationRel >= referenced.robustDeviationThreshold);
    beforeTimeScale = (0:length(beforeDeviationCounts)-1)*original.correlationWindowSeconds;
    afterTimeScale = (0:length(afterDeviationCounts)-1)*referenced.correlationWindowSeconds;
    fractionBefore = mean(beforeDeviationCounts)/numberReferenceChannels;
    fractionAfter = mean(afterDeviationCounts)/numberReferenceChannels;
    fractionAfterRel = mean(afterDeviationRelCounts)/numberReferenceChannels;
    showBadWindows(beforeDeviationCounts, afterDeviationRelCounts, beforeTimeScale, afterTimeScale, ...
        numberReferenceChannels, legendStrings, noisyParameters.name, thresholdName);
    reports = cell(19, 1);
    reports{1} = ['Deviation window statistics (over ' ...
        num2str(size(referenced.channelDeviations, 2)) ' windows)'];
    reports{2} = 'Large deviation channel fraction:';
    reports{3} = [indent ' [before=', ...
        num2str(fractionBefore) ', after=' num2str(fractionAfter) ...
        ', after rel=' num2str(fractionAfterRel) ']'];
    reports{4} = ['Median channel deviation: [before=', ...
        num2str(original.channelDeviationMedian) ...
        ', after=' num2str(referenced.channelDeviationMedian) ']'];
    reports{5} = ['SD channel deviation: [before=', ...
        num2str(original.channelDeviationSD) ...
        ', after=' num2str(referenced.channelDeviationSD) ']'];
    reports{6} = ['Max raw deviation level [before=', ...
        num2str(max(beforeDeviationLevels(:))) ', after=' ...
        num2str(max(afterDeviationLevels(:))) ']'];
    reports{7} = ['Average fraction ' num2str(fractionBefore) ...
               ' (' num2str(mean(beforeDeviationCounts)) ' channels)']; 
    reports{8}= [indent ' not meeting threshold before in each window'];
    reports{9} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterDeviationCounts)) ' channels)'];
    reports{10} = [ indent ' not meeting threshold after in each window'];
    reports{11} = ['Average relative fraction ' num2str(fractionAfterRel) ...
               ' (' num2str(mean(afterDeviationRelCounts)) ' channels)'];
    reports{12} = [indent ' not meeting threshold after relative to before in each window'];
    quarterChannels = round(length(referenceChannels)*0.25);
    halfChannels = round(length(referenceChannels)*0.5);
    reports{13} = 'Windows with > 1/4 deviation channels:';
    reports{14} = [indent '[before=' ...
           num2str(sum(beforeDeviationCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterDeviationCounts > quarterChannels)) ...
        ', after rel=', num2str(sum(afterDeviationRelCounts > halfChannels)) ']'];
    reports{15} = 'Windows with > 1/2 deviation channels:';
    reports{16} = [indent '[before=', ...
        num2str(sum(beforeDeviationCounts > halfChannels)) ...
        ', after=' num2str(sum(afterDeviationCounts > halfChannels)) ...
        ', after rel=', num2str(sum(afterDeviationRelCounts > halfChannels)) ']'];
    reports{17} = ['Median window deviations: [before=', ...
              num2str(medianDeviationsOrig) ', after=' num2str(medianDeviationsRef) ']'];
    reports{18} = ['SD window deviations: [before=', ...
        num2str(sdDeviationsOrig) ', after=' num2str(sdDeviationsRef) ']'];
    if isfield(referenced, 'dropOuts')
        drops = sum(referenced.dropOuts, 2)';
        indexDrops = find(drops > 0);
        dropList = [indexDrops; drops(indexDrops)];
        if ~isempty(indexDrops) > 0
            reportString = sprintf('%g[%g drops] ', dropList(:)');
        else
            reportString = 'None';
        end
        reports{19} = ['Channels with dropouts: ' reportString];
    end
    fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryItem(summaryFile, {reports{1}, reports{2}, reports{3}});
end    
%% Median max correlation (original)
if isfield(noisyParameters, 'reference')
    tString = 'Median max correlation';
    dataOriginal = original.medianMaxCorrelation;
    dataReferenced = referenced.medianMaxCorrelation;
    clim = [0, 1];
    
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end    
%% Median max correlation (referenced)
if isfield(noisyParameters, 'reference')
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end    
%% Correlation window statistics
if isfield(noisyParameters, 'reference')
    beforeCorrelationLevels = original.maximumCorrelations(referenceChannels, :);
    afterCorrelationLevels = referenced.maximumCorrelations(referenceChannels, :);
    thresholdName = 'Maximum correlation';
    theTitle = {char(noisyParameters.name); char([thresholdName ' distribution'])};
    showCumulativeDistributions({beforeCorrelationLevels(:), afterCorrelationLevels(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [0, 1]);
    
    beforeCorrelationCounts = sum(beforeCorrelationLevels <= original.correlationThreshold);
    afterCorrelationCounts = sum(afterCorrelationLevels <= referenced.correlationThreshold);
    beforeTimeScale = (0:length(beforeCorrelationCounts)-1)*original.correlationWindowSeconds;
    afterTimeScale = (0:length(afterCorrelationCounts)-1)*referenced.correlationWindowSeconds;
    showBadWindows(beforeCorrelationCounts, afterCorrelationCounts, beforeTimeScale, afterTimeScale, ...
        numberReferenceChannels, legendStrings, noisyParameters.name, thresholdName);
    fractionBefore = mean(beforeCorrelationCounts)/numberReferenceChannels;
    fractionAfter = mean(afterCorrelationCounts)/numberReferenceChannels;
    reports = cell(10, 1);
    reports{1} = ['Max correlation window statistics (over ' ...
        num2str(size(referenced.maximumCorrelations, 2)) ' windows)'];
    reports{2} = ['Overall median maximum correlation [before=', ...
        num2str(median(original.medianMaxCorrelation(:))) ...
        ', after=' num2str(median(referenced.medianMaxCorrelation(:))) ']'];
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
    quarterChannels = round(length(referenceChannels)*0.25);
    halfChannels = round(length(referenceChannels)*0.5);
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
    writeSummaryItem(summaryFile, {reports{1}, reports{2}});
end
%% Bad ransac fraction (original)
if isfield(noisyParameters, 'reference')
    tString = 'Ransac fraction failed';
    dataOriginal = original.ransacBadWindowFraction;
    dataReferenced = referenced.ransacBadWindowFraction;
    clim = [0, 1];
    
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end    
%% Bad ransac fraction (referenced)
if isfield(noisyParameters, 'reference')
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end    
%% Channels with poor ransac correlations
if isfield(noisyParameters, 'reference')
    beforeRansacLevels = original.ransacCorrelations(referenceChannels, :);
    afterRansacLevels = referenced.ransacCorrelations(referenceChannels, :);
    thresholdName = 'Ransac correlation';
    theTitle = {char([noisyParameters.name ': ' thresholdName ' distribution'])};
    showCumulativeDistributions({beforeRansacLevels(:), afterRansacLevels(:)}, ...
        thresholdName, colors, theTitle, legendStrings, [0, 1]);
    
    beforeRansacCounts = sum(beforeRansacLevels <= original.ransacCorrelationThreshold);
    afterRansacCounts = sum(afterRansacLevels <= referenced.ransacCorrelationThreshold);
    beforeTimeScale = (0:length(beforeRansacCounts)-1)*original.ransacWindowSeconds;
    afterTimeScale = (0:length(afterRansacCounts)-1)*referenced.ransacWindowSeconds;
    showBadWindows(beforeRansacCounts, afterRansacCounts, beforeTimeScale, afterTimeScale, ...
        numberReferenceChannels, legendStrings, noisyParameters.name, thresholdName);
    fractionBefore = mean(beforeRansacCounts)/numberReferenceChannels;
    fractionAfter = mean(afterRansacCounts)/numberReferenceChannels;
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
    quarterChannels = round(length(referenceChannels)*0.25);
    halfChannels = round(length(referenceChannels)*0.5);
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
    writeSummaryItem(summaryFile, {reports{1}, reports{2}});
end    
%% HF noise Z-score (original)
if isfield(noisyParameters, 'reference')
    tString = 'Z-score HF SNR';
    dataOriginal = original.zscoreHFNoise;
    dataReferenced = referenced.zscoreHFNoise;
    medOrig = original.noisinessMedian;
    sdnOrig = original.noisinessSD;
    medRef = referenced.noisinessMedian;
    sdnRef = referenced.noisinessSD;
    dataReferencedRel = ((dataReferenced*sdnRef + medRef) - medOrig)/sdnOrig;
    scale = max(max(abs(dataOriginal), max(abs(dataReferenced))));
    clim = [-scale, scale];  
    plotScalpMap(dataOriginal, originalLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(original)'])
end  
%% HF noise Z-score (referenced)
if isfield(noisyParameters, 'reference')
    plotScalpMap(dataReferenced, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced)'])
end
%% HF noise Z-score (referenced relative to original)
if isfield(noisyParameters, 'reference')    
    plotScalpMap(dataReferencedRel, referencedLocations, scalpMapInterpolation, ...
        showColorbar, headColor, elementColor, clim, nosedir, [tString '(referenced relative)'])
end 
%% HF noise window stats
if isfield(noisyParameters, 'reference')
    beforeNoiseLevels = original.noiseLevels(referenceChannels, :);
    afterNoiseLevels = referenced.noiseLevels(referenceChannels, :);
    medianNoiseOrig = median(beforeNoiseLevels(:));
    sdNoiseOrig = mad(beforeNoiseLevels(:), 1)*1.4826;
    medianNoiseRef = median(afterNoiseLevels(:));
    sdNoiseRef = mad(afterNoiseLevels(:), 1)*1.4826;
    beforeNoise = (beforeNoiseLevels - medOrig)./sdnOrig;
    afterNoiseRel = (afterNoiseLevels - medOrig)./sdnOrig;
    afterNoise = (afterNoiseLevels - medRef)./sdnRef;
    thresholdName = 'HF noise';
    theTitle = {char(noisyParameters.name); [thresholdName ' HF noise distribution']};
    showCumulativeDistributions({beforeNoise(:), afterNoise(:), afterNoiseRel(:)},  ...
        thresholdName, colors, theTitle, legendStrings, [-5, 5]);
    beforeNoiseCounts = sum(beforeNoise  >= original.highFrequencyNoiseThreshold);
    afterNoiseCounts = sum(afterNoise >= referenced.highFrequencyNoiseThreshold);
    afterNoiseRelCounts = sum(afterNoiseRel >= referenced.highFrequencyNoiseThreshold);
    beforeTimeScale = (0:length(beforeNoiseCounts)-1)*original.correlationWindowSeconds;
    afterTimeScale = (0:length(afterNoiseCounts)-1)*referenced.correlationWindowSeconds;
    showBadWindows(beforeNoiseCounts, afterNoiseCounts, beforeTimeScale, afterTimeScale, ...
        length(referenceChannels), legendStrings, noisyParameters.name, thresholdName);
    
    fractionBefore = mean(beforeNoiseCounts)/numberReferenceChannels;
    fractionAfter = mean(afterNoiseCounts)/numberReferenceChannels;
    fractionAfterRel = mean(afterNoiseRelCounts)/numberReferenceChannels;
    reports = cell(17,0);
    reports{1} = ['Noise window statistics (over ' ...
        num2str(size(referenced.noiseLevels, 2)) ' windows)'];
    reports{2} = 'Channel fraction with HF noise:';
    reports{3} = [indent '[before=', ...
                  num2str(fractionBefore) ', after=' num2str(fractionAfter) ...
                 ', after rel=' num2str(fractionAfterRel) ']'];
    reports{4} = ['Median noisiness: [before=', ...
        num2str(original.noisinessMedian) ...
        ', after=' num2str(referenced.noisinessMedian) ']'];
    reports{5} = ['SD noisiness: [before=', ...
        num2str(original.noisinessSD) ...
        ', after=' num2str(referenced.noisinessSD) ']'];
    reports{6} = ['Max HF noise levels [before=', ...
        num2str(max(beforeNoiseLevels(:))) ', after=' ...
        num2str(max(afterNoiseLevels(:))) ']'];
    reports{7} = ['Average fraction ' num2str(fractionBefore) ...
                ' (' num2str(mean(beforeNoiseCounts)) ' channels):'];
    reports{8} = [indent ' not meeting threshold before in each window'];
    reports{9} = ['Average fraction ' num2str(fractionAfter) ...
               ' (' num2str(mean(afterNoiseCounts)) ' channels):'];
    reports{10} = [indent ' not meeting threshold after in each window'];
    reports{11} = ['Average relative fraction ' num2str(fractionAfterRel) ...
               ' (' num2str(mean(afterNoiseRelCounts)) ' channels):'];
    reports{12} = [indent ' not meeting threshold after relative to before in each window'];
    quarterChannels = round(length(referenceChannels)*0.25);
    halfChannels = round(length(referenceChannels)*0.5);
    reports{13} = 'Windows with > 1/4 HF channels:';
    reports{14} = [indent '[before=', ...
        num2str(sum(beforeNoiseCounts > quarterChannels)) ...
        ', after=' num2str(sum(afterNoiseCounts > quarterChannels)) ...
        ', after rel=' num2str(sum(afterNoiseRelCounts > quarterChannels)) ']'];
    reports{15} = 'Windows with > 1/2 HF channels:';
    reports{16} = [indent '[before=', ...
        num2str(sum(beforeNoiseCounts > halfChannels)) ...
        ', after=' num2str(sum(afterNoiseCounts > halfChannels)) ...
        ', after rel=' num2str(sum(afterNoiseRelCounts > halfChannels)) ']'];
    reports{17} = ['Median window HF: [before=', ...
        num2str(medianNoiseOrig) ', after=' num2str(medianNoiseRef) ']'];
    reports{18} = ['SD window HF: [before=', ...
        num2str(sdNoiseOrig) ', after=' num2str(sdNoiseRef) ']'];
     fprintf(consoleFID, '%s:\n', reports{1});
    for k = 2:length(reports)
        fprintf(consoleFID, '%s\n', reports{k});
    end
    writeSummaryItem(summaryFile, {reports{1}, reports{2}, reports{3}});
end
%% Noisy average reference vs robust average reference
if isfield(noisyParameters, 'reference') && isfield(reference, 'averageReference')
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
end   
%% Noisy average reference - robust average reference by time
if isfield(noisyParameters, 'reference')&& isfield(reference, 'averageReference')
    tString = { noisyParameters.name, 'noisy - robust reference signals'};
    t = (0:length(reference.averageReference) - 1)/EEG.srate;
    figure('Name', tString{2})
    plot(t, reference.averageReferenceWithNoisyChannels - ...
        reference.averageReference, '.k');
    xlabel('seconds')
    ylabel('Difference');
    title(tString, 'Interpreter', 'None');
end

