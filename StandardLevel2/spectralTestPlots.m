%%
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
k = 9;
basename = 'vep';
thisName = sprintf('%s_%02d', basename, k);
fname = [indir filesep thisName '.set'];
EEG = pop_loadset(fname);
%load('g.mat')
EEGOrig = EEG;

%% Calculate the correlations and the models
t = 0:(size(EEGOrig.data, 2) - 1);
t = t/EEGOrig.srate;
myData = EEGOrig.data;
myPval = zeros(size(myData, 1), 2);
myCorr = zeros(size(myData, 1), 1);
for k = 1:size(myData, 1)
  myPval(k, :) = polyfit(t, myData(k, :), 1);
  myCorr(k) = corr(t', (myData(k, :))');
end


%% Display the correlation values and the polynomial coefficients
figure('Color', [1, 1, 1])
hold on
h = line([-1, 1], [0, 0], 'Color', [.85, .85, .85], 'LineWidth', 3);
plot(myCorr(1:64), myPval(1:64, 1), 'xk', 'MarkerSize', 12, 'LineWidth', 2)
xlabel('Channel-trend correlation')
ylabel('Slope of trend')
box on
hold off
%% 
figure('Color', [1, 1, 1])
plot(t, myData(1, :), '-k')
xlabel('Seconds')
ylabel('Channel 1 (corr=0.997)')
figure('Color', [1, 1, 1])
plot(t, myData(7, :), '-k')
xlabel('Seconds')
ylabel('Channel 7 (corr=-0.838)')
figure('Color', [1, 1, 1])
plot(t, myData(18, :), '-k')
xlabel('Seconds')
ylabel('Channel 18 (corr=-0.039)')

%%
t1 = [0, 600];
figure('Color', [1, 1, 1])
hold on
h = line(t1, myPval(1, 1)*t1 + myPval(1, 2), 'Color', [1, 0, 0], 'LineWidth', 2);
plot(t, myData(1, :), '-k')
xlabel('Seconds')
ylabel('Channel 1 (corr=0.997)')
hold off
box on
%%
figure('Color', [1, 1, 1])
hold on
h = line(t1, myPval(7, 1)*t1 + myPval(7, 2), 'Color', [1, 0, 0], 'LineWidth', 2);
plot(t, myData(7, :), '-k')
xlabel('Seconds')
ylabel('Channel 7 (corr=-0.838)')
hold off
box on
%%
figure('Color', [1, 1, 1])
hold on
h = line(t1, myPval(18, 1)*t1 + myPval(18, 2), 'Color', [1, 0, 0], 'LineWidth', 2);
plot(t, myData(18, :), '-k')
xlabel('Seconds')
ylabel('Channel 18 (corr=-0.039)')
hold off
box on

%% Display the correlation values and the polynomial coefficients
%% Parameters that must be preset
chans = [1, 7, 18];
EEGSmall = EEGOrig;
EEGSmall.nbchan = length(chans);
EEGSmall.data = EEGOrig.data(chans, :);
params.lineFrequencies = 60;% [60, 120,  180, 212, 240];
params.lineNoiseChannels = 1:3;
params.maximumIterations = 10;
params.fScanBandWidth = 1;
params.pad = 0;
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
[EEGLine, lineNoiseOut] = cleanLineNoise(EEGSmall, params);
[EEGLineFilt, trendOut] = removeTrend(EEGLine, params);
[EEGFilt, trendFiltOut] = removeTrend(EEGSmall, params);
[EEGFiltLine, lineNoiseOutFiltLine] = cleanLineNoise(EEGFilt, params);
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
[EEGModelLine, lineNoiseOutModel] = cleanLineNoise(EEGModel, params);
[EEGModelLineFilt, trendOutModel] = removeTrend(EEGModelLine, params);

%%
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
%%
colors = jet(10);
for k = 1:length(chans)
    tString = [thisName ': Channel ' num2str(chans(k))];   
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
    box on
end
%%
colors = jet(10);
for k = 1:length(chans)
    tString = [thisName ': Channel ' num2str(chans(k))];   
    figure('Name', tString, 'Color', [1, 1, 1])
    hold on
    plot(fOrig{k}, 10*log10(SOrig{k}), 'Color', [0.7, 0.7, 0.7], 'LineWidth', 3, 'LineStyle', '-')
    plot(fFiltLine{k}, 10*log10(SFiltLine{k}), 'Color', [0.85, 0.85, 0.85], 'LineWidth', 6,  'LineStyle', '-')
    % plot(fLine{k}, 10*log10(SLine{k}), 'Color', [0, 0, 0])
    plot(fLineFilt{k}, 10*log10(SLineFilt{k}), 'Color', colors(1, :))
   % plot(fFilt{k}, 10*log10(SFilt{k}), 'Color', colors(2, :))
   
   % plot(fModel{k}, 10*log10(SModel{k}), 'Color', colors(6, :));
   % plot(fModelLine{k}, 10*log10(SModelLine{k}), 'Color', colors(7, :))
    plot(fModelLineFilt{k}, 10*log10(SModelLineFilt{k}), 'Color', [1, 0.2, 0.2])
    legend('Orig', 'Filt-L', 'L-Filt',  'Model-LF');
    %legend('Orig', 'Line', 'L-Filt', 'Filt', 'Filt-L', 'Model', 'Model-L', 'Model-LF');
    hold off
    xlabel('Hz')
    ylabel('Power')
    set(gca, 'XLim', [0, 110], 'XLimMode', 'manual')
    box on
end

% %%
% figure
% hold on
% plot(f, SOrig, 'Color', [0.85, 0.85, 0.85], 'LineWidth', 3, 'LineStyle', '-')
% plot(f, SLine, 'r')
% plot(f, SLineFilt, 'm')
% % plot(f, SFilt, 'b')
% % plot(f, SFiltLine, 'c')
% % plot(f, SButter, 'k');
% % plot(f, SButterLine, 'y')
% legend('Orig', 'Line', 'L-Filt');
% hold off
% 
% 
% %%
% figure
% hold on
% plot(f, SOrig, 'Color', [0.85, 0.85, 0.85], 'LineWidth', 3', 'LineStyle', '-')
% % plot(f, SLine, 'r')
% plot(f, SLineFilt, 'm')
% plot(f, SFilt, 'b')
% plot(f, SFiltLine, 'c')
% % plot(f, SButter, 'k');
% % plot(f, SButterLine, 'y')
% legend('Orig', 'L-Filt', 'Filt', 'Filt-L');
% hold off
% %%
% sum(abs(SLine-SLineFilt))
% sum(abs(SLineFilt-SFiltLine))
% sum(abs(SLine-SFilt))
% sum(abs(SLineFilt-SFilt))
% 
% %%
% t = 0:290303;
% t = t/512;
% myData = EEGOrig.data;
% pval = polyfit(t, myData, 1);
% mycorr = corr(t', (myData)');
% 
% %%
% myModel = polyval(pval, t);
% myError = myData - myModel;
% myMean = mean(myError);
% myStd = std(myError);
% 
% EEGError = EEGOrig;
% EEGError.data = myError;
% EEG = EEGError;
% [EEGErrorLine, SError, SErrorFilt, f, amp, freqs, gFilt] = cleanline('EEG', EEG, g);
%  
% EEGModel = EEGOrig;
% EEGModel.data = myModel;
% EEG = EEGModel;
% [EEGModelLine, SModel, SModelFilt, f, amp, freqs, gFilt] = cleanline('EEG', EEG, g);
% 
% myModel1 = myModel + random('normal', 0, myStd, 1, length(t));
% EEGModel1 = EEGOrig;
% EEGModel1.data = myModel1;
% EEG = EEGModel1;
% [EEGModel1Line, SModel1, SModel1Filt, f, amp, freqs, gFilt] = cleanline('EEG', EEG, g);
% %%
% figure
% hold on
% plot(f, SOrig, 'Color', [0.85, 0.85, 0.85], 'LineWidth', 3, 'LineStyle', '-')
% plot(f, SLine, 'r')
% plot(f, SLineFilt, 'm')
% plot(f, SFilt, 'b')
% plot(f, SFiltLine, 'c')
% plot(f, SModel, 'Color', [0.2, 0.2, 0.8], 'LineWidth', 2, 'LineStyle', '-') 
% plot(f, SModel1, 'Color', [0.1, 0.8, 0.1], 'LineWidth', 2, 'LineStyle', '-') 
% plot(f, SError, 'Color', [0.4, 0.2, 0.8], 'LineWidth', 3, 'LineStyle', '--') 
% plot(f, SErrorFilt, 'Color', [0.4, 0.8, 0.1], 'LineWidth', 3, 'LineStyle', '--') 
% legend('Orig', 'Line', 'L-Filt', 'Filt', 'Filt-L', 'Model', 'Model1', 'Error', 'E-Filt');
% hold off