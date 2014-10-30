function [] = showSpectrum(EEG, channels, tString)


    numChans = 6;
    fftwinfac = 4;
    fftchans = floor(linspace(1, length(channels), numChans));
    colors = jet(length(fftchans));
    [sref, fref]= calculateSpectrum(EEG.data(fftchans, :), ...
        size(EEG.data, 2), EEG.srate, ...
        'freqfac', 4, 'winsize', ...
        fftwinfac*EEG.srate, 'plot', 'off');
    tString1 = {tString,'Selected channels'};
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
    ylabel('Power 10*log(\muV^2/Hz)')
    legend(legends)
    title(tString1, 'Interpreter', 'none')
    drawnow
end