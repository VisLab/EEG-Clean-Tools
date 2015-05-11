function [summary, noisyStatistics] = reportReference(fid, noiseDetection, numbersPerRow, indent)
%% Extracts and outputs parameters for referencing calculation
% Outputs a summary to file fid and returns a cell array of important messages
    summary = {};
    if ~isempty(noiseDetection.errors.reference)
        summary{end+1} =  noiseDetection.errors.reference;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noiseDetection, 'reference')
        summary{end+1} = 'Signal wasn''t referenced';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    reference = noiseDetection.reference;
    noisyStatistics = reference.noisyStatistics;
    fprintf(fid, 'Referencing version %s\n',  ...
        noiseDetection.version.Reference);
    fprintf(fid, 'Reference type %s\n',  reference.referenceType);
    fprintf(fid, 'Interpolation order %s\n',  reference.interpolationOrder);
    fprintf(fid, '\nReference channels (%d channels):\n', ...
        length(reference.referenceChannels));
    printList(fid, reference.referenceChannels, ...
        numbersPerRow, indent);
    fprintf(fid, '\nEvaluation channels (%d channels):\n', ...
        length(reference.evaluationChannels));
    printList(fid, reference.evaluationChannels, ...
        numbersPerRow, indent);
    fprintf(fid, '\nRereferencedChannels (%d channels):\n', ...
        length(reference.rereferencedChannels));
    printList(fid, reference.rereferencedChannels,  ...
        numbersPerRow, indent);
    
    fprintf(fid, 'Noisy channel detection parameters:\n');
    fprintf(fid, '%sRobust deviation threshold (z score): %g\n', ...
        indent, noisyStatistics.robustDeviationThreshold);
    fprintf(fid, '%sHigh frequency noise threshold (ratio): %g\n', ...
        indent, noisyStatistics.highFrequencyNoiseThreshold);
    fprintf(fid, '%sCorrelation window size (in seconds): %g\n', ...
        indent, noisyStatistics.correlationWindowSeconds);
    fprintf(fid, '%sCorrelation threshold (with any channel): %g\n', ...
        indent, noisyStatistics.correlationThreshold);
    fprintf(fid, '%sBad correlation threshold: %g\n', ...
        indent, noisyStatistics.badTimeThreshold);
    fprintf(fid, '%s%s(fraction of time with low correlation or dropout)\n', ...
        indent, indent);
    fprintf(fid, '%sRansac off (if 1 Ransac turned off) : %g\n', ...
        indent, noisyStatistics.ransacOff);
    fprintf(fid, '%sRansac sample size : %g\n', ...
        indent, noisyStatistics.ransacSampleSize);
    fprintf(fid, '%s%s(number channels to use for interpolated estimate)\n', ...
        indent, indent);
    fprintf(fid, '%sRansac channel fraction (for ransac sample size): %g\n', ...
        indent, noisyStatistics.ransacChannelFraction);
    fprintf(fid, '%sRansacCorrelationThreshold: %g\n', ...
        indent, noisyStatistics.ransacCorrelationThreshold);
    fprintf(fid, '%sRansacUnbrokenTime (input parameter): %g\n', ...
        indent, noisyStatistics.ransacUnbrokenTime);
    fprintf(fid, '%sRansacWindowSeconds (in seconds): %g\n', ...
        indent, noisyStatistics.ransacWindowSeconds);
    fprintf(fid, '%sRansacPerformed (if 1, Ransac on and enough channels): %g\n', indent, ...
        noisyStatistics.ransacPerformed);
    fprintf(fid, '%sMaximum reference iterations: %g\n', indent, ...
        getFieldIfExists(reference, 'maxReferenceIterations'));
    fprintf(fid, '%sActual reference iterations: %g\n', indent, ...
          getFieldIfExists(reference, 'actualReferenceIterations'));
    
    %% Listing of noisy channels
    channelLabels = {reference.channelLocations.labels};
    originalBad = reference.interpolatedChannels.all;
    badList = getLabeledList(originalBad,  ...
        channelLabels(originalBad), numbersPerRow, indent);
    summary{end+1} = ['Bad channels interpolated: ' badList];
    fprintf(fid, '\n\nBad channels interpolated:\n %s', badList);
    printBadChannelsByType(fid, reference.interpolatedChannels, channelLabels, numbersPerRow, indent)
    
    finalBad = noisyStatistics.noisyChannels.all;
    badList = getLabeledList(finalBad, channelLabels(finalBad), ...
        numbersPerRow, indent);
    fprintf(fid, '\n\nBad channels after interpolation+referencing:\n %s', badList);
    summary{end+1} = ['Bad channels after interpolation+referencing:' badList];
    printBadChannelsByType(fid, noisyStatistics.noisyChannels, channelLabels, numbersPerRow, indent)
    %% Iteration report
        report = sprintf('\n\nActual interpolation iterations: %d\n', ...
            reference.actualReferenceIterations);
        fprintf(fid, '%s', report);
        summary{end+1} = report;
    
end