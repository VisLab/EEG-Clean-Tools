function [] = visualizeNoiseDetection(noiseDetection, msg, EEG)
fprintf('\nVisualization: %s...\n', msg);
numbersPerRow = 25;
u
visualizeHighPass();
visualizeLineNoise();
visualizeReferenced();
if ~exist('EEG', 'var')
    return;
end

channels = noiseDetection.reference.referenceChannels;
tString = EEG.etc.noiseDetection.name;
makeSpectrum(tString, channels);
if isfield(noiseDetection, 'reference')
    showNoisyChannels(reference.noisyOutOriginal, ...
        reference.channelLocations, reference.channelInformation, ...
        reference.referenceChannels, noiseDetection.name, 'Before referencing');
    showNoisyChannels(reference.noisyOut, ...
        reference.channelLocations, reference.channelInformation, ...
        reference.referenceChannels, noiseDetection.name, ' Final interpolation');
    showBadFrames(reference, tString);
end

%%


%% Visualize the spectra after high-pass filtering
 
%% Visualize reference parameters
 

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