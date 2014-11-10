function summary = reportLineNoise(fid, noisyParameters, numbersPerRow, indent)
% Outputs a summary of line noise removal to file fid and returns a cell array of important messages
    summary = cell(1, 0);
    if ~isfield(noisyParameters, 'lineNoise')
        summary{1} = 'Signal didn''t have line noise removed\n';
        fprintf(fid, '%s\n', summary{1});
        return;
    end
    lineNoise = noisyParameters.lineNoise;
    fprintf(fid, '%sVersion %s\n', indent, ...
        noisyParameters.version.LineNoise);
    fprintf(fid, '%sSampling frequency Fs: %g Hz\n', indent, lineNoise.Fs);
    fprintf(fid, '%sLine noise frequencies:\n', indent);
    printList(fid, lineNoise.lineFrequencies, numbersPerRow, [indent, indent]);
    fprintf(fid, '%sMaximum iterations: %d\n', indent, ...
        lineNoise.maximumIterations);
    fprintf(fid, '%sSignificant frequency p-value: %g\n', indent, lineNoise.p);
    fprintf(fid, '%s+/- frequency BW for significant peaks (fScanBandWidth): %g\n', ...
        indent, lineNoise.fScanBandWidth);
    fprintf(fid, '%sTaper bandwidth: %d Hz\n', indent, lineNoise.taperBandWidth);
    fprintf(fid, '%sTaper window size: %d\n', indent, lineNoise.taperWindowSize);
    fprintf(fid, '%sTaper step size: %d\n', indent, lineNoise.taperWindowStep);
    fprintf(fid, '%sSigmoidal smoothing factor (tau): %g\n', indent, ...
        lineNoise.tau);
    fprintf(fid, '%sSpectral pad factor: %d\n', indent, lineNoise.pad);
    fprintf(fid, '%sAnalysis frequency interval(fPassBand): [ %g, %g ] Hz\n', ...
        indent, lineNoise.fPassBand);
    fprintf(fid, '%sTaper template: [ %g, %g, %g ]\n', indent, ...
        lineNoise.taperTemplate);
    fprintf(fid, '%sLine noise channels:\n', indent);
    printList(fid, lineNoise.lineNoiseChannels, numbersPerRow, [indent, indent]);
end

