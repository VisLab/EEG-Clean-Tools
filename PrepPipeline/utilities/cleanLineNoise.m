function [signal, lineNoiseOut] = cleanLineNoise(signal, lineNoiseIn)
% Remove sharp spectral peaks from signal using Sleppian filters
%
% Usage:
% signal = cleanLineNoise(signal)
% [signal, lineNoiseOut] = hcleanLineNoise(signal, lineNoiseIn)
%
% Parameters:
%    signal          Structure with .data and .srate fields
%    lineNoiseIn     Input structure with fields described below
%
% Structure parameters (lineNoiseIn):
%    fPassBand       Frequency band used (default [0, Fs/2] = entire band)
%    Fs 	            Sampling frequency 
%    fScanBandWidth  +/- bandwidth centered on each f0 to scan for significant
%                       lines (TM)
%    lineFrequencies Line frequencies to be removed (default 
%                       [60, 120, 180, 240, 300])
%    lineNoiseChannels  Channels to remove line noise from (default
%                       size(data, 1))
%    maximumIterations   Maximum times to iterate removal (default = 10)
%    p               Significance level cutoff (default = 0.01)
%    pad             FFT padding factor ( -1 corresponds to no padding, 
%                       0 corresponds to padding to next highest power of 2
%                       etc.) (default is 0)
%    pnts
%    tapers          Precomputed tapers from dpss
%    taperBandWidth  Taper bandwidth (default 2 Hz)
%    taperWindowSize Taper sliding window length (default 4 sec)
%    taperWindowStep Sliding window step size (default 4 sec = no overlap)
%    tau             Window overlap smoothing factor (default 100)
%
% This function is based on code originally written by Tim Mullen in a 
% package called tmullen-cleanline which is based on the chronux_2
% libraries.
%

lineNoiseOut = lineNoiseIn;
%% Remove line frequencies that are greater than Nyquist frequencies
tooLarge = lineNoiseOut.lineFrequencies >= lineNoiseOut.Fs/2;
if any(tooLarge)
    warning('cleanLineNoise:LineFrequenciesTooLarge', ...
        'Eliminating frequencies greater than half the sampling rate');
    lineNoiseOut.lineFrequencies(tooLarge) = [];
    lineNoiseOut.lineFrequencies = squeeze(lineNoiseOut.lineFrequencies);
end

%% Set up multi-taper parameters
hbw = lineNoiseOut.taperBandWidth/2;   % half-bandwidth
lineNoiseOut.taperTemplate = [hbw, lineNoiseOut.taperWindowSize, 1];
Nwin = round(lineNoiseOut.Fs*lineNoiseOut.taperWindowSize); % number of samples in window
lineNoiseOut.tapers = checkTapers(lineNoiseOut.taperTemplate, Nwin, lineNoiseOut.Fs); 

%% Perform the calculation for each channel separately
signal.data = double(signal.data);
chans = lineNoiseOut.lineNoiseChannels;
data = signal.data(chans, :);
parfor ch = 1:size(data, 1)
    data(ch, :) = removeLinesMovingWindow(squeeze(data(ch, :)), lineNoiseOut);
end
signal.data(chans, :) = data;
clear data;

