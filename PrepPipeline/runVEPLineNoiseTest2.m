%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
load('EEGsmall.set', '-mat');
params = struct();
%% Parameters that must be preset
params.lineFrequencies = 60;% [60, 120,  180, 212, 240];
params.lineNoiseChannels = 1;
params.maximumIterations = 10;
params.fScanBandWidth = 1;
params.pad = 0;
[EEGLine, lineNoiseOut] = cleanLineNoise(EEG, params);

%%
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
params.referenceType = 'robust';
basenameOut = [basename 'Rev_cutoff' num2str(params.detrendCutoff)];
[EEGLineFilt, trendOut] = removeTrend(EEGLine, params);


%%
[EEGFilt, trendFiltOut] = removeTrend(EEG, params);
[EEGFiltLine, lineNoiseOutFiltLine] = cleanLineNoise(EEGFilt, params);
%% See what the spectrom looks like 
[SOrig,fOrig]=mtspectrumsegc(EEG.data,lineNoiseOut.taperWindowSize,lineNoiseOut);
[SLine,fLine]=mtspectrumsegc(EEGLine.data,lineNoiseOut.taperWindowSize,lineNoiseOut);
[SLineFilt,fLineFilt]=mtspectrumsegc(EEGLineFilt.data,lineNoiseOut.taperWindowSize,lineNoiseOut);
[SFilt,fFilt]=mtspectrumsegc(EEGFilt.data,lineNoiseOut.taperWindowSize,lineNoiseOut);
[SFiltLine,fFiltLine]=mtspectrumsegc(EEGFiltLine.data,lineNoiseOut.taperWindowSize,lineNoiseOut);

% %% Save the various versions
% save('EEGOrig.set', 'EEG', '-v7.3');
% EEGTemp = EEG;
% EEG = EEGLineFilt;
% save('EEGLineFilt.set', 'EEG', '-v7.3');
% EEG = EEGFilt;
% save('EEGFilt.set', 'EEG', '-v7.3');
% EEG = EEGLine;
% save('EEGLine.set', 'EEG', '-v7.3');
% EEG = EEGFiltLine;
% save('EEGFiltLine.set', 'EEG', '-v7.3');
% EEG = EEGTemp;
%%
figure
hold on
plot(fOrig, 10*log10(SOrig), 'Color', [0.8, 0.8, 0.8], 'LineWidth', 3' , 'LineStyle', '-')
plot(fLine, 10*log10(SLine), 'r')
plot(fLineFilt, 10*log10(SLineFilt), 'm')
plot(fFilt, 10*log10(SFilt), 'b')
plot(fFiltLine, 10*log10(SFiltLine), 'c')
legend('Orig', 'Line', 'L-Filt', 'Filt', 'Filt-L')
xlabel('Hz')
ylabel('Power')
hold off


%%
figure
hold on
%plot(fLine, SLine, 'r')
plot(fLineFilt, SLineFilt, 'm')
% plot(fFilt, 10*log10(SFilt), 'b')
plot(fFiltLine, SFiltLine, 'c')
legend('L-Filt', 'L-Filt')
xlabel('Hz')
ylabel('Power')
hold off

%%
% channels = 1%:70;
% numChans = min(6, length(channels));
% indexchans = floor(linspace(1, length(channels), numChans));
% displayChannels = channels(indexchans);
% channelLabels = {EEG.chanlocs(channels).labels};
% [badChannels, fref, sref] = showSpectrum(EEG, channels,  ...
%     displayChannels, channelLabels, 'Original' );
% [badChannelsBefore, frefBefore, srefBefore] = showSpectrum(EEGBefore, channels, ...
%     displayChannels, channelLabels, 'Line noise no filtering' );
% [badChannelsBeforeFilt, frefBeforeFilt, srefBeforeFilt] = showSpectrum(EEGBeforeFiltered, channels,  ...
%     displayChannels, channelLabels, 'Line noise filtered' );
% [badChannelsFiltered, frefFiltered, srefFiltered] = showSpectrum(EEGFiltered, channels, ...
%     displayChannels, channelLabels, 'Filtered' );
% [badChannelsAfter, frefAfter, srefAfter] = showSpectrum(EEGAfter, channels,  ...
%     displayChannels, channelLabels, 'Filtered line noise' );
%         [Sorig(k,:)  f] = mtspectrumsegc(data,movingwin(1),params);
%         [Sclean(k,:) f] = mtspectrumsegc(datac,movingwin(1),params);
% %%
% 
% 
% 
% 
% load('tempData.mat');
% 
% %%
% load('tempDataNew.mat');
% 
% %%
% totalDiffFval = 0;
% totalDiffasig = 0;
% totalDiffAmps = 0;
% for k = 1:length(aFvalOld)
%     totalDiffFval = totalDiffFval + abs(FvalSigSave{k} - aFvalOld{k}{1});
%     totalDiffasig = totalDiffasig + abs(sigSave{k} - asigOld{k});
%     totalDiffAmps = totalDiffAmps + abs(aSigSave{k} - Amps{k}{1});
% end
% 
% %%
% totalData = zeros(1, size(tempData, 2));
% for k = 1:size(tempData, 2);
%     totalData(k) = sum(abs(tempData(:, k) - datafitWinSave(:, k)));
% end
% 
% %%
% load('EEGTim.set', '-mat')
% 
% %%
% diffEEG = abs(EEG.data - EEGBefore.data);
% sum(diffEEG)
% 
% %%
% EEG = EEGBeforeFiltered;
% save('EEGBeforeFilt.set', 'EEG', '-v7.3');
% 
% %%
% EEG = EEGFiltered;
% save('EEGFilt.set', 'EEG', '-v7.3');