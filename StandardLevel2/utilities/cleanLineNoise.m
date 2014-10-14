function [signal, lineNoiseOut] = cleanLineNoise(signal, lineNoiseIn)
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
%    taperWindowSize Taper sliding window length (default 4 sec)
%    taperWindowStep Sliding window step size (default 4 sec = no overlap)
%    tau             Window overlap smoothing factor (default 100)
%
% This function is based on code originally written by Tim Mullen in a 
% package called tmullen-cleanline which is based on the chronux_2
% libraries.
%
%% Check the incoming parameters
if nargin < 1
    error('cleanLineNoise:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('cleanLineNoise:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('cleanLineNoise:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('cleanLineNoise:NoData', 'signal data must have multiple points');
elseif ~exist('lineNoiseIn', 'var') || isempty(lineNoiseIn)
    lineNoiseIn = struct();
elseif isempty(lineNoiseIn) || ~isstruct(lineNoiseIn)
    error('cleanLineNoise:NoData', 'second argument must be a structure')
end

%% Set the defaults to appropriate values
lineNoiseOut = struct();
lineNoiseOut.Fs = getStructureParameters(lineNoiseIn, 'Fs', signal.srate);
lineNoiseOut.lineNoiseChannels = getStructureParameters(lineNoiseIn, 'lineNoiseChannels', 1:size(signal.data, 1));
lineNoiseOut.lineFrequencies = getStructureParameters(lineNoiseIn, 'lineFrequencies', [60, 120, 180]);
lineNoiseOut.p = getStructureParameters(lineNoiseIn, 'p', 0.01);
lineNoiseOut.fScanBandWidth = getStructureParameters(lineNoiseIn, 'fScanBandWidth', 2);
lineNoiseOut.taperBandWidth = getStructureParameters(lineNoiseIn, 'taperBandWidth', 2);
lineNoiseOut.taperWindowSize = getStructureParameters(lineNoiseIn, 'taperWindowSize', 4);
lineNoiseOut.taperWindowStep = getStructureParameters(lineNoiseIn, 'taperWindowStep', 1);
lineNoiseOut.tau = getStructureParameters(lineNoiseIn, 'tau', 100);
lineNoiseOut.pad = getStructureParameters(lineNoiseIn, 'pad', 0);  % Pad of 2 is slower but gives better results
lineNoiseOut.fPassBand = getStructureParameters(lineNoiseIn, 'fPassBand', [45, (lineNoiseOut.Fs)/2]);                                           
lineNoiseOut.maximumIterations = getStructureParameters(lineNoiseIn, 'maximumIterations', 10);
if any(lineNoiseOut.lineNoiseChannels > size(signal.data, 1))
    error('cleanLineNoise:Invalidchannels', ...
        'Channels are not present in the dataset');
end

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
data = double(signal.data);
data1 = zeros(size(data));
chans = sort(lineNoiseOut.lineNoiseChannels);
parfor ch = chans
    data1(ch, :) = removeLinesMovingWindow(squeeze(data(ch, :)), lineNoiseOut);
end
signal.data = data1;
clear data;
clear data1;






