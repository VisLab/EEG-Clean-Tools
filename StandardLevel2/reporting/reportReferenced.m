function summary = reportReferenced(fid, noisyParameters, numbersPerRow, indent)
%% Extracts and outputs parameters for referencing calculation
% Outputs a summary to file fid and returns a cell array of important messages
    summary = {};
    if ~isempty(noisyParameters.errors.reference)
        summary{end+1} =  noisyParameters.errors.reference;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noisyParameters, 'reference')
        summary{end+1} = 'Signal wasn''t referenced';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    reference = noisyParameters.reference;
    fprintf(fid, '%sRereferencing version %s\n', indent, ...
        noisyParameters.version.Reference);
    fprintf(fid, '%sSampling rate: %g Hz\n', indent, reference.noisyOut.srate);

    fprintf(fid, '%sNoisy channel detection parameters:\n', indent);
    fprintf(fid, '%s%sRobust deviation threshold (z score): %g\n', ...
        indent, indent, reference.noisyOut.robustDeviationThreshold);
    fprintf(fid, '%s%sHigh frequency noise threshold (ratio): %g\n', ...
        indent, indent, reference.noisyOut.highFrequencyNoiseThreshold);
    fprintf(fid, '%s%sCorrelation window size (in seconds): %g\n', ...
        indent, indent, reference.noisyOut.correlationWindowSeconds);
    fprintf(fid, '%s%sCorrelation threshold (with any channel): %g\n', ...
        indent, indent, reference.noisyOut.correlationThreshold);
    fprintf(fid, '%s%sBad correlation threshold: %g\n', ...
        indent, indent, reference.noisyOut.badTimeThreshold);
    fprintf(fid, '%s%s%s(fraction of time with low correlation)\n', ...
        indent, indent, indent);
    fprintf(fid, '%s%sRansac sample size : %g\n', ...
        indent, indent, reference.noisyOut.ransacSampleSize);
    fprintf(fid, '%s%s%s(number channels to use for interpolated estimate)\n', ...
        indent, indent, indent);
    fprintf(fid, '%s%sRansac channel fraction (for ransac sample size): %g\n', ...
        indent, indent, reference.noisyOut.ransacChannelFraction);
    fprintf(fid, '%s%sRansacCorrelationThreshold: %g\n', ...
        indent, indent, reference.noisyOut.ransacCorrelationThreshold);
    fprintf(fid, '%s%sRansacUnbrokenTime (input parameter): %g\n', ...
        indent, indent, reference.noisyOut.ransacUnbrokenTime);
    fprintf(fid, '%s%sRansacWindowSeconds (in seconds): %g\n', ...
        indent, indent, reference.noisyOut.ransacWindowSeconds);
    fprintf(fid, '%s%sRansacPerformed: %g\n', indent, indent, ...
        reference.noisyOut.ransacPerformed);
    fprintf(fid, '%s%sInterpolateHFChannels: %g\n', indent, indent, ...
        reference.interpolateHFChannels);
    fprintf(fid, '\n%sReference channels (%d channels):\n', ...
        indent, length(reference.referenceChannels));
    printList(fid, reference.referenceChannels, ...
        numbersPerRow, [indent, indent]);
    fprintf(fid, '\n%sRereferencedChannels (%d channels):\n', ...
        indent, length(reference.rereferencedChannels));
    printList(fid, reference.rereferencedChannels,  ...
        numbersPerRow, [indent, indent]);
    
    %% Listing of noisy channels
    outOriginal = reference.noisyOutOriginal;
    out = reference.noisyOut;
    channelLabels = {reference.channelLocations.labels};
    fprintf(fid, '\n\n%sNoisy channels before referencing:\n', indent);
    printLabeledList(fid, outOriginal.noisyChannels,  ...
        channelLabels(outOriginal.noisyChannels), numbersPerRow, [indent, indent]);
    fprintf(fid, '\n%sNoisy channels interpolated after referencing:\n', indent);
    printList(fid, reference.interpolatedChannels, numbersPerRow, [indent, indent]);
    if ~isempty(reference.interpolatedChannels)
        summary{end+1} = ['Interpolated channels: ' ...
        getListString(reference.interpolatedChannels)];
    end
 
    fprintf(fid, '\n%sRemaining noisy channels:\n', indent);
    printList(fid, reference.noisyOut.noisyChannels, numbersPerRow, [indent, indent]);
    if ~isempty(reference.noisyOut.noisyChannels)
        summary{end+1} = ['Potential noisy channels remaining: ' ...
        getListString(reference.noisyOut.noisyChannels)];
    end
    fprintf(fid, '\n%sRemaining bad channels that haven''t been interpolated:\n', ...
        indent);
    printList(fid, reference.badChannelsNotInterpolated, numbersPerRow, [indent, indent]);
    if ~isempty(reference.badChannelsNotInterpolated)
        summary{end+1} = ['Remaining bad channels that haven''t been interpolated:', ...
        getListString(reference.badChannelsNotInterpolated)];
    end
 
    % Maximum correlation criterion
    fprintf(fid, '\n\n%sBad by max correlation criteria (original):\n', indent);
    printList(fid, reference.noisyOutOriginal.badChannelsFromCorrelation, ...
        numbersPerRow, [indent, indent]);
    fprintf(fid, '\n%sBad by max correlation criteria (rereferenced):\n', indent);
    printList(fid, reference.noisyOut.badChannelsFromCorrelation, ...
        numbersPerRow, [indent, indent]);
    % Large deviation criterion
    fprintf(fid, '\n\n%sBad by large deviation criteria (original):\n', indent);
    printList(fid, reference.noisyOutOriginal.badChannelsFromDeviation, ...
        numbersPerRow, [indent, indent]);
    fprintf(fid, '\n\n%sBad by large deviation criteria (rereferenced):\n', indent);
    printList(fid, reference.noisyOut.badChannelsFromDeviation, ...
        numbersPerRow, [indent, indent]);

        
    % HF SNR ratio criterion
    fprintf(fid, '\n\n%sBad by high frequency noise (low SNR) criteria (original):\n', indent);
    printList(fid, reference.noisyOutOriginal.badChannelsFromHFNoise, ...
        numbersPerRow, [indent, indent]);
    fprintf(fid, '\n%sBad by high frequency noise (low SNR) criteria (referenced):\n', indent);
    printList(fid, reference.noisyOut.badChannelsFromHFNoise, ...
        numbersPerRow, [indent, indent]);
       fprintf(fid, '\n\n%sMedian noisiness = %g (original)\n', ...
            indent, reference.noisyOutOriginal.noisinessMedian);
      
    %% Noisiness indicators
    fprintf(fid, '\n\n%sMedian channel deviation = %g (original)\n', ...
            indent, reference.noisyOutOriginal.channelDeviationMedian);
    fprintf(fid, '\n\n%sSD channel deviation = %g (original)\n', ...
            indent, reference.noisyOutOriginal.channelDeviationSD);
    fprintf(fid, '\n\n%sMedian channel deviation = %g (rereferenced)\n', ...
            indent, reference.noisyOut.channelDeviationMedian);
    fprintf(fid, '\n\n%sSD channel deviation = %g (referenced)\n', ...
            indent, reference.noisyOut.channelDeviationSD);
    fprintf(fid, '\n\n%sSD noisiness = %g (original)\n', ...
            indent, reference.noisyOutOriginal.noisinessSD);
    fprintf(fid, '\n\n%sMedian noisiness = %g (rereferenced)\n', ...
            indent, reference.noisyOut.noisinessMedian);
    fprintf(fid, '\n\n%sSD noisiness = %g (referenced)\n', ...
            indent, reference.noisyOut.noisinessSD);
        
    % Bad by ransac
    fprintf(fid, '\n\n%sBad by Ransac criteria (original):\n', indent);
    printList(fid, reference.noisyOutOriginal.badChannelsFromRansac, ...
        numbersPerRow, [indent, indent]);
        fprintf(fid, '\n%sBad by Ransac criteria (rereferenced):\n', indent);
    printList(fid, reference.noisyOut.badChannelsFromRansac, ...
        numbersPerRow, [indent, indent]);
 
end