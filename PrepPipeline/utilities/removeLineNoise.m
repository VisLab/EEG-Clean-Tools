function [signal, lineNoiseOut] = removeLineNoise(signal, lineNoiseIn)
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
%% Check the incoming parameters
if nargin < 1
    error('removeLineNoise:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('removeLineNoise:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('removeLineNoise:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('removeLineNoise:NoData', 'signal data must have multiple points');
elseif ~exist('lineNoiseIn', 'var') || isempty(lineNoiseIn)
    lineNoiseIn = struct();
elseif isempty(lineNoiseIn) || ~isstruct(lineNoiseIn)
    error('removeLineNoise:NoData', 'second argument must be a structure')
end

%% Set the defaults to appropriate values
defaults = getPrepDefaults(signal, 'linenoise');
lineNoiseOut = struct('lineNoiseMethod', [], ...
    'lineNoiseChannels', [], 'Fs', [], ...
    'lineFrequencies', [], 'p', [], 'fScanBandWidth', [], ...
    'taperBandWidth', [], 'taperWindowSize', [], ...
    'taperWindowStep', [], 'tau', [], 'pad', [], ...
    'fPassBand', [], 'maximumIterations', []);

[lineNoiseOut, errors] = checkDefaults(lineNoiseIn, lineNoiseOut, defaults);
if ~isempty(errors)
    error('removeLineNoise:BadParameters', ['|' sprintf('%s|', errors{:})]);
end

if strcmpi(lineNoiseOut.lineNoiseMethod, 'clean')
    [signal, lineNoiseOut] = cleanLineNoise(signal, lineNoiseOut);
elseif strcmpi(lineNoiseOut.lineNoiseMethod, 'blasst')
    [signal, lineNoiseOut] = blasstLineNoise(signal, lineNoiseOut);
elseif ~strcmpi(lineNoiseOut.lineNoiseMethod, 'none')
    error('removeLineNoise:BadLineNoiseMethod', ...
          'Unrecognized line noise removal method');
end
