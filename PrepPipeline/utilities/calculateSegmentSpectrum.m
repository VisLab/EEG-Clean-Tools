function [S, f] = calculateSegmentSpectrum(data, lineNoise)
% Multi-taper segmented spectrum for a univariate continuous process
%
% Usage:
%     [S, f] = calculateSegmentSpectrum(data, lineNoise)
%
% Parameters:
%      data      (single channel) -- required
%      lineNoise   structure with various parameters set
%
% The lineNoise structure has the following fields set:
%       fPassBand       Frequency band used
%       Fs 	            Sampling frequency 
%       pad             FFT padding factor 
%       tapers          Precomputed tapers from dpss
%       taperWindowSize Taper sliding window length 
%
% Output:
%       S       Spectrum 
%       f       Frequencies
%

%% Check input arguments for consistency
if nargin < 2  
    error('calculateSegmentSpectrum:NotEnoughArguments', ...
        'Need to provide data and segment information arguments'); 
end

data = change_row_to_column(data);
if size(data, 2) ~= 1; 
    error('calculateSegmentSpectrum:DataNot1Dim', ...
        'Data must beunivariate time series'); 
end
%% Extract argument values
win = getStructureParameters(lineNoise, 'taperWindowSize', 4);
Fs = getStructureParameters(lineNoise, 'Fs', 1);
pad = getStructureParameters(lineNoise, 'pad', 0);
fpass = getStructureParameters(lineNoise, 'fPassBand', [0 lineNoise.Fs/2]);

%% Create the segmented data for the calculation of the spectrum
N = size(data, 1); % length of segmented data
dt = 1/Fs; % sampling interval
T = N*dt; % length of data in seconds
E = 0:win:(T - win); % fictitious event triggers
win = [0, win]; % use window length to define left and right limits of windows around triggers
data = createdatamatc(data, E, Fs, win); % segmented data
N = size(data,1); % length of segmented data
nfft = max(2^(nextpow2(N) + pad), N);
[f, findx] = getfgrid(Fs, nfft, fpass); 
tapers = lineNoise.tapers;
J = mtfftc(data, tapers, nfft, Fs); % compute tapered fourier transforms
J = J(findx, :, :); % restrict to specified frequencies
S = squeeze(mean(conj(J).*J, 2)); % spectra of non-overlapping segments (average over tapers)
S = squeeze(mean(S, 2)); % Mean of the spectrum averaged across segments
