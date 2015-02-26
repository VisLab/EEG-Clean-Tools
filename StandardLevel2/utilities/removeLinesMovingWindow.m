function data = removeLinesMovingWindow(data, lineNoise)
% Removes significant sine waves from (continuous) data using overlapping windows.
%
% Usage:
%    data = removeLinesMovingWindow(data, lineNoise)
%
% Parameters
%       data        data in [N,1] (a single time column vector)
%       lineNoise   structure with various parameters set
%
% The lineNoise structure has the following fields set:
%       fPassBand       Frequency band used 
%       Fs 	            Sampling frequency 
%       fScanBandWidth  +/- bandwidth centered on each f0 to scan for significant
%                       lines (TM)
%       lineFrequencies Line frequencies to be removed 
%       maximumIterations   Maximum times to iterate removal 
%       p               Significance level cutoff 
%       pad             FFT padding factor 
%       tapers          Precomputed tapers from dpss
%       taperWindowSize Taper sliding window length (seconds) 
%       taperWindowStep Sliding window step size (seconds)
%       tau             Window overlap smoothing factor 
%
% Output:
%       data           Cleaned up data
%
if nargin < 2
    error('removeLinesMovingWindow:NotEnoughArguments', ...
        'Need data and window parameters');
end;
Fs = getStructureParameters(lineNoise, 'Fs');
tau = getStructureParameters(lineNoise, 'tau');

% Window,overlap and frequency information
data = change_row_to_column(data);
N = size(data, 1);
Nwin = round(Fs*lineNoise.taperWindowSize); % number of samples in window
Nstep = round(lineNoise.taperWindowStep*Fs); % number of samples to step through
Noverlap = Nwin - Nstep; % number of points in overlap
x = (1:Noverlap)';
smooth = 1./(1+exp(-tau.*(x - Noverlap/2)/Noverlap)); % sigmoidal function
winstart = 1:Nstep:(N - Nwin + 1);
nw = length(winstart);
datafit = zeros(winstart(nw) + Nwin - 1, 1);

fidx = zeros(length(lineNoise.lineFrequencies), 1);
f0 = lineNoise.lineFrequencies;
[initialSpectrum, f] = calculateSegmentSpectrum(data, lineNoise);
initialSpectrum = 10*log10(initialSpectrum);
for fk = 1:length(lineNoise.lineFrequencies)
    [dummy, fidx(fk)] = min(abs(f - lineNoise.lineFrequencies(fk))); %#ok<ASGLU>
end

for iteration = 1:lineNoise.maximumIterations
    f0Mask = false(1, length(f0));
%     datafitWinSave = zeros(Nwin, nw);   % Debugging
%     f0SigSave = cell(nw, 1); % Debugging
%     FvalSigSave = cell(nw, 1);  % Debugging
%     aSigSave = cell(nw, 1);  % Debugging
%     fSigSave = cell(nw, 1);  % Debugging
%     sigSave = cell(nw, 1);   % Debugging
    for n = 1:nw
        indx = winstart(n):(winstart(n) + Nwin - 1);
        datawin = data(indx);
         [datafitwin, f0Sig] = ...
            fitSignificantFrequencies(datawin, f0, lineNoise);
%         [datafitwin, f0Sig, FvalSig, aSig, fSig, sig] = ...
%             fitSignificantFrequencies(datawin, f0, lineNoise);
        datafitwin0 = datafitwin;
%         datafitWinSave(:, n) = datafitwin0;  % Debugging
%         f0SigSave{n} = f0Sig; % Debugging
%         FvalSigSave{n} = FvalSig;  % Debugging
%         aSigSave{n} = aSig;  % Debugging
%         fSigSave{n} = fSig;  % Debugging
%         sigSave{n} = sig;   % Debugging
        f0Mask = f0Mask | f0Sig;
        if n > 1
            datafitwin(1:Noverlap)= smooth.*datafitwin(1:Noverlap) + ...
                (1 - smooth).*datafitwin0((Nwin - Noverlap + 1):Nwin);
        end;
        datafit(indx, :) = datafitwin;
    end
%     save('tempDataNew.mat', 'datafitWinSave', 'f0SigSave', ...
%          'FvalSigSave', 'aSigSave', 'fSigSave', 'sigSave', 'lineNoise', '-v7.3');  % Debugging

    data(1:size(datafit, 1)) = data(1:size(datafit, 1)) - datafit;
    if sum(f0Mask) > 0
        % Now find the line frequencies that have converged
        cleanedSpectrum = calculateSegmentSpectrum(data, lineNoise);
        cleanedSpectrum = 10*log10(cleanedSpectrum); 
        dBReduction = initialSpectrum - cleanedSpectrum;
%         for fk=1:length(fidx)
%             fprintf('%0.4g Hz: %0.4g dB %s ',f(fidx),dBReduction(fidx));
%             fprintf('\n');
%         end
        tIndex = (dBReduction(fidx) < 0)';
        f0(tIndex | ~f0Mask) = [];
        fidx(tIndex | ~f0Mask) = [];
        initialSpectrum = cleanedSpectrum;
    end
    if isempty(f0)
        break;
    end 
end
data = data';