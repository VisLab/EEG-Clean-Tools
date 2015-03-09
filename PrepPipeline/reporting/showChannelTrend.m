function [] = showChannelTrend(EEG, EEGChannels, displayChannels, seconds)
%% Displays the trend line for EEG over an interval
%
% Parameters
%    EEG              EEGLAB EEG structure
%    EEGChannels      vector numbers of channels corresponding to EEG
%    displayChannels  vector containing list of channels to visualize
%    seconds          interval (in seconds) to analyze (empty = all)
%
% This function shows a mumber of visualizations both in time and 
% frequency space 
%

%% Set up the data to be visualized
EEGOrig = EEG;
t = 0:(size(EEGOrig.data, 2) - 1);
t = t/EEGOrig.srate;
if ~isempty(seconds)
    tIndex = (t >= seconds(1) & t <= seconds(2));
    t = t(tIndex);
    EEGOrig.data = EEGOrig.data(:, tIndex);
    EEGOrig.pnts = sum(tIndex);
    EEGOrig.times = EEGOrig.times(tIndex);
end

%% Display channels must be EEG channels
displayChannels = intersect(EEGChannels, displayChannels);

%% Calculate the correlations and the models

myData = EEGOrig.data;
myPval = zeros(size(myData, 1), 2);
myCorr = zeros(size(myData, 1), 1);
for k = 1:size(myData, 1)
  myPval(k, :) = polyfit(t, myData(k, :), 1);
  myCorr(k) = corr(t', (myData(k, :))');
end
 
%% Display the correlation values and the polynomial coefficients
cTitle = 'Summary of trends for EEG channels';
figure('Color', [1, 1, 1], 'Name', cTitle)
hold on
line([-1, 1], [0, 0], 'Color', [.85, .85, .85], 'LineWidth', 3);
plot(myCorr(EEGChannels), myPval(EEGChannels, 1), 'xk', 'MarkerSize', 12, 'LineWidth', 2)
xlabel('Channel-trend correlation')
ylabel('Slope of trend')
title(cTitle)
box on
hold off

%%
for k = 1:length(displayChannels)
    chan = displayChannels(k);
    myTitle = ['Channel ' num2str(chan) ' (corr=' num2str(myCorr(chan)) ')']; 
    figure('Color', [1, 1, 1], 'Name', myTitle)
    plot(t, myData(chan, :), '-k')
    t1 = get(gca, 'XLim');
    hold on
    line(t1, myPval(chan, 1)*t1 + myPval(chan, 2), 'Color', [1, 0, 0], 'LineWidth', 2);
    xlabel('Seconds')
    ylabel('Voltage (uV)')
    hold off
    box on
end

%% Display the correlation values and the polynomial coefficients
%% Parameters that must be preset
chans = displayChannels;
EEGSmall = EEGOrig;
EEGSmall.nbchan = length(chans);
EEGSmall.data = EEGOrig.data(chans, :);
params.detrendType = 'high pass';
params.detrendCutoff = 1;
[EEGLine, lineNoiseOut] = cleanLineNoise(EEGSmall, params);
EEGLineFilt = removeTrend(EEGLine, params);
EEGFilt = removeTrend(EEGSmall, params);
EEGFiltLine = cleanLineNoise(EEGFilt, params);
%% Remove from model
t = 0:(size(EEGSmall.data, 2) - 1);
t = t/EEGSmall.srate;
EEGModel = EEGSmall;
for k = 1:length(chans)
  ch = chans(k);
  myModel = polyval(myPval(ch, :), t);
  EEGModel.data(k, :) = EEGModel.data(k, :) - myModel;
end
%%
EEGModelLine = cleanLineNoise(EEGModel, params);
EEGModelLineFilt = removeTrend(EEGModelLine, params);

%% Compute the filtering for models and EEG
SOrig = cell(length(chans), 1);
fOrig = cell(length(chans), 1);
SFilt = cell(length(chans), 1);
fFilt = cell(length(chans), 1);
SFiltLine = cell(length(chans), 1);
fFiltLine = cell(length(chans), 1);
SLine = cell(length(chans), 1);
fLine = cell(length(chans), 1);
SLineFilt = cell(length(chans), 1);
fLineFilt = cell(length(chans), 1);
SModel = cell(length(chans), 1);
fModel = cell(length(chans), 1);
SModelLine = cell(length(chans), 1);
fModelLine = cell(length(chans), 1);
SModelLineFilt = cell(length(chans), 1);
fModelLineFilt = cell(length(chans), 1);
winSize = lineNoiseOut.taperWindowSize;
sParams = lineNoiseOut;
for k = 1:length(chans)
   [SOrig{k},fOrig{k}] = mtspectrumsegc(EEGSmall.data(k, :), winSize, sParams);
   [SLine{k},fLine{k}] = mtspectrumsegc(EEGLine.data(k, :), winSize, sParams);
   [SLineFilt{k},fLineFilt{k}] = mtspectrumsegc(EEGLineFilt.data(k, :), winSize, sParams);
   [SFilt{k},fFilt{k}] = mtspectrumsegc(EEGFilt.data(k, :), winSize, sParams);
   [SFiltLine{k},fFiltLine{k}] = mtspectrumsegc(EEGFiltLine.data(k, :), winSize, sParams);
   [SModel{k},fModel{k}] = mtspectrumsegc(EEGModel.data(k, :), winSize, sParams);
   [SModelLine{k},fModelLine{k}] = mtspectrumsegc(EEGModelLine.data(k, :), winSize, sParams);
   [SModelLineFilt{k},fModelLineFilt{k}] = mtspectrumsegc(EEGModelLineFilt.data(k, :), winSize, sParams);
end
%% Figures with the entire spectral range and all filtering variations
thisName = EEG.setname;
colors = jet(10);
for k = 1:length(chans)
    tString = [thisName ': Channel ' num2str(chans(k)) ' (all versions)'];   
    figure('Name', tString, 'Color', [1, 1, 1])
    hold on
    plot(fOrig{k}, 10*log10(SOrig{k}), 'Color', [0.85, 0.85, 0.85], 'LineWidth', 3', 'LineStyle', '-')
    plot(fLine{k}, 10*log10(SLine{k}), 'Color', [0, 0, 0])
    plot(fLineFilt{k}, 10*log10(SLineFilt{k}), 'Color', colors(1, :))
    plot(fFilt{k}, 10*log10(SFilt{k}), 'Color', colors(2, :))
    plot(fFiltLine{k}, 10*log10(SFiltLine{k}), 'Color', colors(4, :))
    plot(fModel{k}, 10*log10(SModel{k}), 'Color', colors(6, :));
    plot(fModelLine{k}, 10*log10(SModelLine{k}), 'Color', colors(7, :))
    plot(fModelLineFilt{k}, 10*log10(SModelLineFilt{k}), 'Color', colors(10, :)')
    legend('Orig', 'Line', 'L-Filt', 'Filt', 'Filt-L', 'Model', 'Model-L', 'Model-LF');
    hold off
    xlabel('Hz')
    ylabel('Power')
    title(tString, 'Interpreter', 'none')
    box on
end
%% Figures with just interaction of filtering and line noise -- limited range
for k = 1:length(chans)
    tString = [thisName ': Channel ' num2str(chans(k)) ' (limited spectrum)'];   
    figure('Name', tString, 'Color', [1, 1, 1])
    hold on
    plot(fOrig{k}, 10*log10(SOrig{k}), 'Color', [0.7, 0.7, 0.7], 'LineWidth', 3, 'LineStyle', '-')
    plot(fFiltLine{k}, 10*log10(SFiltLine{k}), 'Color', [0.85, 0.85, 0.85], 'LineWidth', 6,  'LineStyle', '-')
    plot(fLineFilt{k}, 10*log10(SLineFilt{k}), 'Color', [0, 0, .8])
    plot(fModelLineFilt{k}, 10*log10(SModelLineFilt{k}), 'Color', [1, 0.2, 0.2])
    legend('Orig', 'Filt-L', 'L-Filt',  'Model-LF');
    hold off
    xlabel('Hz')
    ylabel('Power')
    set(gca, 'XLim', [0, 110], 'XLimMode', 'manual')
    title(tString, 'Interpreter', 'none')
    box on
end