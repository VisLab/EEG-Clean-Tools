%% Example 1 (Default arguments)
clear;
load('EEG.mat')
[eegspecdB,freqs] = calculateSpectrum(EEG.data,size(EEG.data, 2),EEG.srate);  %#ok<NASGU>
numchans = size(eegspecdB);
for k = 1:numchans
    tString = ['EEG channel ' num2str(k)];
    figure('Name', tString)
    %hold on
    plot(freqs, eegspecdB(k, :)', 'k')
    %plot(fref, sref, 'r')
    %hold off
    xlabel('Frequency (Hz)')
    ylabel('Power 10*log(uV2/Hz)')
    %legend('High pass only', 'Line noise removed')
    title(tString, 'Interpreter', 'none')
end
%% Example 2 (Additional arguments)
%clear;
load('EEG.mat')
fftwinfac = 2;
[eegspecdB,freqs] = calculateSpectrum(EEG.data,size(EEG.data, 2),EEG.srate, ...
    'freqfac', 4, 'winsize', fftwinfac*EEG.srate);