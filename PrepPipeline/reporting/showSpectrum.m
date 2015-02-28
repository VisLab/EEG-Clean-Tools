function [badChannels, fref, sref] = showSpectrum(EEG, channels, displayChannels, ...
    channelLabels, tString)
% Calculate EEG spectra and show at display displayChannels
    fftwinfac = 4;
    sref = cell(length(channels), 1);
    fref = cell(length(channels), 1);
    badList = false(length(channels), 1);
    tempData = EEG.data(channels, :);
    srate = EEG.srate;
    numFrames = size(EEG.data, 2);
    fftFactor = fftwinfac*EEG.srate;
    parfor k = 1:length(channels)
      [sref{k}, fref{k}]= calculateSpectrum(tempData(k, :), ...
           numFrames, srate, 'freqfac', 4, 'winsize', ...
           fftFactor, 'plot', 'off');
       if isempty(sref{k})
           badList(k) = true;
       end
    end   
    badChannels = channels(badList);
    if ~isempty(displayChannels)
        tString1 = {tString,'Selected channels'};
        displayChannels = intersect(channels, displayChannels);
        displayChannels = setdiff(displayChannels, badChannels);

        colors = jet(length(displayChannels));
        figure('Name', tString)
        hold on
        legends = cell(1, length(displayChannels));
        for c = 1:length(displayChannels)
            fftchan = displayChannels(c);
            plot(fref{fftchan}, sref{fftchan}', 'Color', colors(c, :))
            legends{c} = [num2str(fftchan) ' (' channelLabels{fftchan} ')'];
        end
        hold off
        xlabel('Frequency (Hz)')
        ylabel('Power 10*log(\muV^2/Hz)')
        legend(legends)
        title(tString1, 'Interpreter', 'none')
        drawnow
    end
end