function [] = visualizeNoisyParameters(noisyParameters, msg, EEG)
fprintf('\nVisualization: %s...\n', msg);
tname = '';
channels = [];
[tname, channels]  = visualizeHighPass(tname, channels);
[tname, channels]  = visualizeLineNoise(tname, channels);
[tname, channels]  = visualizeRereferenced(tname, channels);
if ~exist('EEG', 'var')
    return;
end

tString = [EEG.etc.noisyParameters.name ' : ' tname];
makeSpectrum(tString, channels);
if strcmp(tname, 'reference')
    showNoisyChannels(reference.noisyChannelOriginal, ...
        reference.channelLocations, reference.channelInformation, ...
        reference.referenceChannels, noisyParameters.name, 'Before referencing');
    showNoisyChannels(reference.noisyChannelResults, ...
        reference.channelLocations, reference.channelInformation, ...
        reference.referenceChannels, noisyParameters.name, ' Final interpolation');
end

    function [tname, channels] = visualizeHighPass(tname, channels)
        if ~isfield(noisyParameters, 'highPass')
            fprintf('Signal wasn''t high pass filtered\n');
            return;
        end
        highPass = noisyParameters.highPass;
        fprintf('\nHigh pass filtering %s\n', ...
            noisyParameters.version.HighPass);
        fprintf('\tHigh pass cutoff: %g Hz\n', highPass.highPassCutoff);
        fprintf('\tFilter command: %s\n', highPass.filterCommand);
        fprintf('\tHigh pass filtered channels: [ ');
        fprintf('%d ', highPass.highPassChannels);
        fprintf(']\n');
        tname = 'high pass';
        channels = noisyParameters.highPass.highPassChannels;
    end

%% Visualize the spectra after high-pass filtering
    function [tname, channels] = visualizeLineNoise(tname, channels)
        if ~isfield(noisyParameters, 'lineNoise')
            fprintf('Signal didn''t have line noise removed\n');
            return;
        end
        lineNoise = noisyParameters.lineNoise;
        fprintf('\nLine noise removal %s\n', ...
            noisyParameters.version.LineNoise);
        fprintf('\tSampling frequency Fs: %g Hz\n', lineNoise.Fs);
        fprintf('\tLine frequencies: [ ');
        fprintf('%d ', lineNoise.lineNoiseChannels);
        fprintf(']\n');
        
        fprintf('\tMaximum number of iterations: %d\n', ...
            lineNoise.maximumIterations);
        fprintf('\tp-value for significant frequencies: %g\n', lineNoise.p);
        fprintf('\t+/- frequency band in which to look for significant peaks (fScanBandWidth): %g\n', ...
            lineNoise.fScanBandWidth);
        fprintf('\tTaper bandwidth: %d Hz\n', lineNoise.taperBandWidth);
        fprintf('\tTaper window size: %d\n', lineNoise.taperWindowSize);
        fprintf('\tTaper step size: %d\n', lineNoise.taperWindowStep);
        fprintf('\tSpectral sigmoidal smoothing factor (tau): %g\n', ...
            lineNoise.tau);
        fprintf('\tSpectral pad factor: %d\n', lineNoise.pad);
        fprintf('\tSpectral pad factor: %d\n', lineNoise.pad);
        fprintf('\tFrequency interval to analyze (fPassBand): [ %g, %g ] Hz\n', ...
            lineNoise.fPassBand);
        fprintf('\tSpectral smoothing factor tau: %d\n', lineNoise.tau);
        fprintf('\tTaper template: [ %g, %g, %g ]\n', lineNoise.taperTemplate);
        tname = 'lineNoise';
        channels = noisyParameters.lineNoise.lineNoiseChannels;
    end

    function [tname, channels] = visualizeRereferenced(tname, channels)
        if ~isfield(noisyParameters, 'reference')
            fprintf('Signal wasn''t rereferenced\n');
            return;
        end
        reference = noisyParameters.reference;
        fprintf('\nRereferencing %s\n', ...
            noisyParameters.version.Reference);
        fprintf('\tSampling rate: %g Hz\n', reference.srate);
        
        fprintf('\tReference channels: [ ');
        fprintf('%d ', reference.referenceChannels);
        fprintf(']\n');
        
        fprintf('\tRereferenced channels: [ ');
        fprintf('%d ', reference.rereferencedChannels);
        fprintf(']\n');
        
        fprintf('\tNoisy channel detection parameters:\n');
        fprintf('\t\tRobust deviation threshold (z score): %g\n', ...
            reference.robustDeviationThreshold);
        fprintf('\t\tHigh frequency noise threshold (ratio): %g\n', ...
            reference.highFrequencyNoiseThreshold);
        fprintf('\t\tCorrelation window size (in seconds): %g\n', ...
            reference.correlationWindowSeconds);
        fprintf('\t\tCorrelation threshold (with any channel): %g\n', ...
            reference.correlationThreshold);
        fprintf('\t\tBad correlation threshold (fraction of time with low correlation): %g\n', ...
            reference.badTimeThreshold);
        fprintf('\t\tRansac sample size (number channels to use for interpolated estimate): %g\n', ...
            reference.ransacSampleSize);
        fprintf('\t\tRansac channel fraction (used to get the sample size): %g\n', ...
            reference.ransacChannelFraction);
        fprintf('\t\tRansacCorrelationThreshold: %g\n', ...
            reference.ransacCorrelationThreshold);
        fprintf('\t\tRansacUnbrokenTime (in seconds): %g\n', ...
            reference.ransacUnbrokenTime);
        fprintf('\t\tRansacWindowSeconds (in seconds): %g\n', ...
            reference.ransacWindowSeconds);
        fprintf('\t\tDo ransac after removing bad channels by other methods: %g\n', ...
            reference.doRansacAfterBadRemoval);
        
        fprintf('\tNoisy channels before referencing: [ ');
        fprintf('%g ', reference.noisyChannelOriginal.noisyChannels);
        fprintf(']\n');
        fprintf('\tNoisy channels interpolated after referencing: [ ');
        fprintf('%g ', reference.interpolatedChannels);
        fprintf(']\n');
        fprintf('\tRemaining noisy channels: [ ');
        fprintf('%g ', reference.noisyChannelResults.noisyChannels);
        fprintf(']\n');
        fprintf('\t\tBad by max correlation criteria: [');
        fprintf('%g ', reference.noisyChannelResults.badChannelsFromCorrelation);
        fprintf(']\n');
        fprintf('\t\tBad by large deviation criteria: [');
        fprintf('%g ', reference.noisyChannelResults.badChannelsFromDeviation);
        fprintf(']\n');
        fprintf('\t\tBad by high frequency noise (low SNR) criteria: [');
        fprintf('%g ', reference.noisyChannelResults.badChannelsFromHFNoise);
        fprintf(']\n');
        fprintf('\t\tBad by Ransac criteria: [');
        fprintf('%g ', reference.noisyChannelResults.badChannelsFromRansac);
        fprintf(']\n');
        tname = 'reference';
        channels = noisyParameters.reference.referenceChannels;
    end

    function makeSpectrum(tString, channels)
        numChans = 6;
        fftwinfac = 4;
        fftchans = floor(linspace(1, length(channels), numChans));
        colors = jet(length(fftchans));
        [sref, fref]= calculateSpectrum(EEG.data(fftchans, :), ...
            size(EEG.data, 2), EEG.srate, ...
            'freqfac', 4, 'winsize', ...
            fftwinfac*EEG.srate, 'plot', 'off');
        figure('Name', tString)
        hold on
        legends = cell(1, length(fftchans));
        for c = 1:length(fftchans)
            fftchan = channels(fftchans(c));
            plot(fref, sref(c, :)', 'Color', colors(c, :))
            legends{c} = num2str(fftchan);
        end
        hold off
        xlabel('Frequency (Hz)')
        ylabel('Power 10*log(uV2/Hz)')
        legend(legends)
        title(tString, 'Interpreter', 'none')
        drawnow
    end

end