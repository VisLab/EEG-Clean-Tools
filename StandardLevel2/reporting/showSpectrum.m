function [] = showSpectrum(EEG, channels, channelLabels, tString)
% Show spectrum of EEG at channels selected from 
    fftwinfac = 4;
    colors = jet(length(channels));
    [sref, fref]= calculateSpectrum(EEG.data(channels, :), ...
        size(EEG.data, 2), EEG.srate, ...
        'freqfac', 4, 'winsize', ...
        fftwinfac*EEG.srate, 'plot', 'off');
    tString1 = {tString,'Selected channels'};
    figure('Name', tString)
    hold on
    legends = cell(1, length(channels));
    for c = 1:length(channels)
        fftchan = channels(c);
        plot(fref, sref(c, :)', 'Color', colors(c, :))
        legends{c} = [num2str(fftchan) ' (' channelLabels{c} ')'];
    end
    hold off
    xlabel('Frequency (Hz)')
    ylabel('Power 10*log(\muV^2/Hz)')
    legend(legends)
    title(tString1, 'Interpreter', 'none')
    drawnow
end