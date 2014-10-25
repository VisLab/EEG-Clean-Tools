function reportLineNoise( noisyParameters, numbersPerRow, indent)
%% Extracts and outputs parameters for lineNoise calculation
    if ~isfield(noisyParameters, 'lineNoise')
        fprintf('Signal didn''t have line noise removed\n');
        return;
    end
    lineNoise = noisyParameters.lineNoise;
    fprintf('%sVersion %s\n', indent, ...
        noisyParameters.version.LineNoise);
    fprintf('%sSampling frequency Fs: %g Hz\n', indent, lineNoise.Fs);
    fprintf('%sLine noise frequencies:\n', indent);
    printList(lineNoise.lineFrequencies, numbersPerRow, [indent, indent]);
    fprintf('%sMaximum iterations: %d\n', indent, ...
        lineNoise.maximumIterations);
    fprintf('%sSignificant frequency p-value: %g\n', indent, lineNoise.p);
    fprintf('%s+/- frequency BW for significant peaks (fScanBandWidth): %g\n', ...
        indent, lineNoise.fScanBandWidth);
    fprintf('%sTaper bandwidth: %d Hz\n', indent, lineNoise.taperBandWidth);
    fprintf('%sTaper window size: %d\n', indent, lineNoise.taperWindowSize);
    fprintf('%sTaper step size: %d\n', indent, lineNoise.taperWindowStep);
    fprintf('%sSigmoidal smoothing factor (tau): %g\n', indent, ...
        lineNoise.tau);
    fprintf('%sSpectral pad factor: %d\n', indent, lineNoise.pad);
    fprintf('%sAnalysis frequency interval(fPassBand): [ %g, %g ] Hz\n', ...
        indent, lineNoise.fPassBand);
    fprintf('%sTaper template: [ %g, %g, %g ]\n', indent, ...
        lineNoise.taperTemplate);
    fprintf('%sLine noise channels:\n', indent);
    printList(lineNoise.lineNoiseChannels, numbersPerRow, [indent, indent]);
end

