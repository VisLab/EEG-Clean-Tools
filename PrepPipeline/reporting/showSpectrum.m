function [fref, sref, badChannels] = showSpectrum(EEG, channelLabels, ...
    channels, displayChannels, tString, maxChannelsPerFigure)
% Calculate EEG spectra for channels and show display displayChannels
%
% Parameters:
%    EEG              EEGLAB EEG structure
%    channels         vector of channel numbers to calculate spectrum for
%    displayChannels  vector of channels to display (no plot if empty)
%    channelLabels    cell array of labels corresponding to all channels
%    tString          title of plot if there is a display
%    maxChannelsPerFigure maximum number of channels per figure
%
% Output:
%    fref             vector of spectral frequencies in Hz
%    sref             vector of spectral powers in 10*log(\muV^2/Hz)
%    badChannels      vector of channels with failed spectrum (should be
%                     empty unless there are serious issues)
%
%  Written by: Kay Robbins, UTSA, 2015
%
%  Uses calculateSpectrum -- adapted from EEGLAB
%
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
    %displayChannels = setdiff(displayChannels, badChannels);
    numberPlots = ceil(length(displayChannels)/maxChannelsPerFigure);
    perPlot = ceil(length(displayChannels)/numberPlots);
    for k = 1:numberPlots
        startChannel = perPlot*(k - 1) + 1;
        endChannel = min(startChannel + perPlot - 1, length(displayChannels));
        showChannels(displayChannels(startChannel:endChannel));
    end
end

    function [] = showChannels(theseChannels)
        colors = jet(length(theseChannels));
        figure('Name', tString, 'Color', [1, 1, 1])
        hold on
        legendCount = 0;
        legends = cell(1, length(theseChannels));
        for c = 1:length(theseChannels)
            fftchan = theseChannels(c);
            f = fref{fftchan}(:);
            s = sref{fftchan}(:);
            if isempty(f) || isempty(s) || length(f) ~= length(s)
                continue;
            end
            plot(fref{fftchan}(:), sref{fftchan}(:), 'Color', colors(c, :));
            legendCount = legendCount + 1;
            legends{legendCount} = [num2str(fftchan) ' (' channelLabels{fftchan} ')'];
        end
        hold off
        xlabel('Frequency (Hz)')
        ylabel('Power 10*log(\muV^2/Hz)')
        if ~isempty(legends)
            legends = legends(~cellfun('isempty',legends));
            ht = legend(legends, 'Location', 'EastOutside');
            if ~verLessThan('matlab', '9.0.0') 
               title(ht, 'Current ch#(label)')
            end
        end
        title(tString1, 'Interpreter', 'none')
        box on
        drawnow
    end
end
