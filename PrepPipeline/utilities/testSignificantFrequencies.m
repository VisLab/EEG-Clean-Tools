function [Fval, A, f, sig ] = testSignificantFrequencies(data, lineNoise)
% Computes the F-statistic for sine wave in locally-white noise (continuous data).
%
% Usage:
%     [Fval, A, f, sig ,sd] = testSignificantFrequencies(data,lineNoise)
%
% Parameters:
%      data        Single channel -- required
%      lineNoise   Structure with various parameters set
%
% The lineNoise structure has the following fields set:
%       fPassBand       Frequency band used 
%       Fs 	            Sampling frequency 
%       p               Significance level cutoff 
%       pad             FFT padding factor 
%       tapers          Precomputed tapers from dpss
%       taperWindowSize Taper sliding window length 
%
%  Outputs: 
%       Fval        F-statistic in frequency x 1 form
%  	    A		    Line amplitude for X in frequency x 1 
%	    f		    Frequencies of evaluation 
%       sig         F distribution (1-p)% confidence level
%

%% Process the input arguments
if nargin < 1
    error('testSignificantFrequencies:NoData', ...
          'Must provide data as the first argument'); 
elseif nargin < 2
    error('testSignificantFrequencies:NoParameters', ...
          'Must provide a lineNoise parameter structure as second argument'); 
end
pad = getStructureParameters(lineNoise, 'pad');
Fs = getStructureParameters(lineNoise, 'Fs');
fpass = getStructureParameters(lineNoise, 'fPassBand');

data = change_row_to_column(data);
C = size(data, 2);
p = getStructureParameters(lineNoise, 'p', 0.01);
tapers = getStructureParameters(lineNoise, 'tapers'); % Calculate the actual tapers
if isempty(tapers)
    error('testSignificantFrequencies:NoTapers', ...
          'Must provide a tapers field in the lineNoise parameter structure');  
end

[N, K] = size(tapers);
nfft = max(2^(nextpow2(N) + pad), N);% number of points in fft
[f, findx] = getfgrid(Fs, nfft, fpass);% frequency grid to be returned

%% Now compute the taper spectrum
Kodd = 1:2:K;
Keven = 2:2:K;
J = mtfftc(data, tapers, nfft, Fs);% tapered fft of data - f x K x C
Jp = J(findx, Kodd, :); % drop the even ffts and restrict fft to specified frequency grid - f x K x C
tapers = tapers(:, :, ones(1, C)); % add channel indices to the tapers - t x K x C
H0 = squeeze(sum(tapers(:, Kodd, :), 1)); % calculate sum of tapers for even prolates - K x C 
if C == 1
    H0=H0';
end;
Nf = length(findx); % Number of frequencies
H0 = H0(:, :, ones(1, Nf)); % Add frequency indices to H0 - K x C x f
H0 = permute(H0,[3, 1, 2]); % Permute H0 to get dimensions to match those of Jp - f x K x C 
H0sq = sum(H0.*H0, 2); % Sum of squares of H0^2 across taper indices - f x C
JpH0 = sum(Jp.*squeeze(H0), 2);% sum of the product of Jp and H0 across taper indices - f x C
A = squeeze(JpH0./H0sq); % amplitudes for all frequencies and channels
Kp = size(Jp, 2); % number of even prolates
Ap = A(:, :, ones(1, Kp)); % add the taper index to C
Ap = permute(Ap,[1, 3, 2]); % permute indices to match those of H0
Jhat = Ap.*H0; % fitted value for the fft

num = (K - 1).*(abs(A).^2).*squeeze(H0sq);%numerator for F-statistic
den = squeeze(sum(abs(Jp - Jhat).^2, 2) + ...
    sum(abs(J(findx, Keven, :)).^2, 2));% denominator for F-statistic
Fval = num./den; % F-statisitic
sig = finv(1 - p, 2, 2*K - 2); % F-distribution based 1-p% point
A = A*Fs;

