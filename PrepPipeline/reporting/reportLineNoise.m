function summary = reportLineNoise(fid, noiseDetection, numbersPerRow, indent)
% Outputs a summary of line noise removal to file fid and returns a cell array of important messages
    summary = {};
    if isfield(noiseDetection.errors, 'lineNoise') && ...
            ~isempty(noiseDetection.errors.lineNoise)
        summary{end+1} =  noiseDetection.errors.lineNoise;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noiseDetection, 'lineNoise')
        summary{end+1} = 'Signal didn''t have line noise removed';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    lineNoise = noiseDetection.lineNoise;
    if isfield(lineNoise, 'lineNoiseMethod')
        summary{end + 1} = ['Line noise method: ' ...
                             num2str(lineNoise.lineNoiseMethod)];
    else
        summary{end + 1} = 'Line noise method: clean';
    end
    fprintf(fid, '%s\n', summary{end});
    fprintf(fid, 'Sampling frequency Fs: %g Hz\n', lineNoise.Fs);
    fprintf(fid, 'Line noise frequencies:\n');
    printList(fid, lineNoise.lineFrequencies, numbersPerRow, indent);
    fprintf(fid, 'Maximum iterations: %d\n', lineNoise.maximumIterations);
    fprintf(fid, 'Significant frequency p-value: %g\n', lineNoise.p);
    fprintf(fid, '+/- frequency BW for significant peaks (fScanBandWidth): %g\n', ...
        lineNoise.fScanBandWidth);
    fprintf(fid, 'Taper bandwidth: %d Hz\n', lineNoise.taperBandWidth);
    fprintf(fid, 'Taper window size (seconds): %d\n', lineNoise.taperWindowSize);
    fprintf(fid, 'Taper step size (seconds): %d\n', lineNoise.taperWindowStep);
    fprintf(fid, 'Sigmoidal smoothing factor (tau): %g\n',  ...
        lineNoise.tau);
    fprintf(fid, 'Spectral pad factor: %d\n', lineNoise.pad);
    fprintf(fid, 'Analysis frequency interval(fPassBand): [ %g, %g ] Hz\n', ...
        lineNoise.fPassBand);
    if isfield(lineNoise, 'taperTemplate')
        fprintf(fid, 'Taper template: [ %g, %g, %g ]\n', ...
        lineNoise.taperTemplate);
    end
    fprintf(fid, 'Line noise channels (%d channels):\n', ...
        length(lineNoise.lineNoiseChannels));
    printListCompressed(fid, lineNoise.lineNoiseChannels, numbersPerRow, indent);
end

