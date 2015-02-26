function [datafit, f0Significant, FvalSig, aSig, fSig, sig]= ...
                           fitSignificantFrequencies(data, f0, lineNoise)
% Fits significant sine waves to specified peaks in continuous data
%
% Usage: 
%   [datafit, f0Significant] = fitSignificantFrequencies(data, f0, lineNoise)  
%
% Parameters:
%      data        Single channel -- required
%      f0          Vector with the line frequencies to be removed 
%      lineNoise   Structure with various parameters set
%
% The lineNoise structure has the following fields set:
%       fPassBand       Frequency band used 
%       fScanBandWidth  +/- bandwidth centered on each f0 to scan for significant
%                       lines (TM)
%       Fs 	            Sampling frequency 
%       p               Significance level cutoff 
%       pad             FFT padding factor 
%       tapers          Precomputed tapers from dpss
%       taperWindowSize Taper sliding window length 
%
%  Outputs:
%       datafit          Linear superposition of fitted sine waves
%       f0Significant    f0 values found to be significant
%
data = change_row_to_column(data);
N = size(data, 1);

fscanbw = getStructureParameters(lineNoise, 'fScanBandWidth');
Fs = getStructureParameters(lineNoise, 'Fs');

[Fval, A, f, sig] = testSignificantFrequencies(data, lineNoise);
datafit = zeros(N, 1);
  
frequencyMask = false(1, length(f));
f0Significant = false(1, length(f0));
if ~isempty(fscanbw)
    % For each line f0(n), scan f0+-BW/2 for largest significant peak of Fval
    for n = 1:length(f0)
        % Extract scan range around f0 ( f0 +- fscanbw/2 )
        [~, ridx(1)] = min(abs(f - (f0(n) - fscanbw/2)));
        [~, ridx(2)] = min(abs(f - (f0(n) + fscanbw/2)));
        
        Fvalscan = Fval(ridx(1):ridx(2));
        Fvalscan(Fvalscan < sig) = 0;
        if any(Fvalscan)
            % If there's a significant line, pull the max one
            [~, rmaxidx] = max(Fvalscan);
            indx = ridx(1) + rmaxidx - 1;
            frequencyMask(indx) = true;
            f0Significant(n) = true;
        end    
    end
else
    % Remove exact lines if significant
    for n = 1:length(f0);
        [~, itemp] = min(abs(f - f0(n)));
        frequencyMask(itemp) = Fval(itemp) >= sig;
        f0Significant(n) = frequencyMask(itemp);
    end;   
end
 
% Estimate the contribution of any significant f0 lines
fSig = f(frequencyMask);
aSig = A(frequencyMask);
FvalSig = Fval(frequencyMask);
if ~isempty(fSig)
    datafit = exp(1i*2*pi*(0:(N - 1))'*fSig/Fs)* aSig ...
        + exp(-1i*2*pi*(0:(N - 1))'*fSig/Fs)*conj(aSig);
end