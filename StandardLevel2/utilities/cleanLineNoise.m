function [signal, lineNoise] = cleanLineNoise(signal, lineNoise)
%
% Usage:
%    data = removeLinesMovingWindow(data, lineNoise)
%
% Parameters:
%    data        data in [N,1] (a single time column vector)
%    lineNoise   structure with various parameters set
%
% The lineNoise structure has the following fields set:
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
elseif ~exist('lineNoise', 'var') || isempty(lineNoise)
    lineNoise = struct();
elseif isempty(lineNoise) || ~isstruct(lineNoise)
    error('cleanLineNoise:NoData', 'second argument must be a structure')
end

%% Set the defaults to appropriate values
lineNoise = getSignalParameters(lineNoise, 'Fs', signal, 'Fs', 1);
lineNoise = getStructureParameters(lineNoise, 'lineNoiseChannels', 1:size(signal.data, 1));
lineNoise = getStructureParameters(lineNoise, 'lineFrequencies', [60, 120, 180]);
lineNoise = getStructureParameters(lineNoise, 'p', 0.01);
lineNoise = getStructureParameters(lineNoise, 'fScanBandWidth', 2);
lineNoise = getStructureParameters(lineNoise, 'taperBandWidth', 2);
lineNoise = getStructureParameters(lineNoise, 'taperWindowSize', 4);
lineNoise = getStructureParameters(lineNoise, 'taperWindowStep', 1);
lineNoise = getStructureParameters(lineNoise, 'tau', 100);
lineNoise = getStructureParameters(lineNoise, 'pad', 0);  % Pad of 2 is slower but gives better results
lineNoise = getStructureParameters(lineNoise, 'fPassBand', [45, lineNoise.Fs/2]);                                           
lineNoise = getStructureParameters(lineNoise, 'maximumIterations', 10);
%lineNoise = getStructureParameters(lineNoise, 'tolerance', 1);
if any(lineNoise.lineNoiseChannels > size(signal.data, 1))
    error('clean_line:Invalidchannels', ...
        'Channels are not present in the dataset');
end

%% Remove line frequencies that are greater than Nyquist frequencies
tooLarge = lineNoise.lineFrequencies >= lineNoise.Fs/2;
if any(tooLarge)
    warning('cleanLineNoise:LineFrequenciesTooLarge', ...
        'Eliminating frequencies greater than half the sampling rate');
    lineNoise.lineFrequencies(tooLarge) = [];
    lineNoise.lineFrequencies = squeeze(lineNoise.lineFrequencies);
end

%% Set up multi-taper parameters
hbw = lineNoise.taperBandWidth/2;   % half-bandwidth
lineNoise.taperTemplate = [hbw, lineNoise.taperWindowSize, 1];
Nwin = round(lineNoise.Fs*lineNoise.taperWindowSize); % number of samples in window
lineNoise.tapers = checkTapers(lineNoise.taperTemplate, Nwin, lineNoise.Fs); 

%% Perform the calculation for each channel separately
lineNoise.iterationCounts = zeros(length(lineNoise.lineNoiseChannels), ...
                                  length(lineNoise.lineFrequencies));
data = double(signal.data);
data1 = zeros(size(data));
parfor ch = lineNoise.lineNoiseChannels
    data1(ch, :) = removeLinesMovingWindow(squeeze(data(ch, :)), lineNoise);
end
signal.data = data1;






