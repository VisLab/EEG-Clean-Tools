function [y,x] = blasst_internal(x,f,r,sR,scale,rez,manualOffset)
% blasst_internal(): An iteration of BLASST feature fitting.
% Takes a 1-dimensional signal and fits a series of Gabor atoms (arranged
% so that the enveloping Gaussian functions add up to a partition of unity)
% to try and remove the target frequency (f) within a range (\pm r), while
% respecting the time-frequency power distribution of the surrounding
% spectral bands.
%
% INPUT:
% x     is [1,N] time series signal.
% f     is the target frequency (a scalar, NOT normalized) ex. 60 for 60 Hz
% r     is the target frequency range within which we seek to remove noise.
%       For example, if line noise is not stationary, we might seek to
%       remove noise between 57 and 63 Hz, in which case r = 3.
% sR    is the sampling rate of the signal.
% scale is the integer scale for Gabor atoms.      
% rez   is an integer >= 1 that specifies the density of Gabor atoms in the
%       partition of unity. rez must take an integer value so that Gaussian
%       functions add up to unity.
% manualOffset  is a scalar that offsets the centers of atoms at the outset
%               of computation.
%
% OUTPUT:
% y     the [1,N] time course of signal features removed from x.
% x     the [1,N] transformed signal.
%
% AUTHOR: Kenneth Ball, 2015.
% 
% IF YOU FIND BLASST USEFUL IN YOUR WORK, PLEASE CITE:
%
% Ball, K. R., Hairston, W. D., Franaszczuk, P. J., Robbins, K. A., 
% BLASST: Band Limited Atomic Sampling with Spectral Tuning with 
% Applications to Utility Line Noise Filtering, [Under Review].
%
% Copyright 2015 Kenneth Ball
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.



N = length(x);
y = zeros(size(x));
n2 = scale*2; % half-window length
n = 2*n2+1; % win length
win = (-n2):(n2);

% timejump and estimate amplitude scaling for partition of unity of Gaussian functions:
timeJump = scale/rez/sqrt(pi);
R = -(rez*10):(rez*10);
scalingFactor = 1./sum(exp(-R.^2/rez.^2));

% spec frequency ranges:
fs = sR*(0:(1/(2*scale)):.5);
fs = fs(intersect(find(fs>=(f-r)),find(fs<=(f+r))));

wavelets = complexGabor(fs/sR,scale,0,win); % wavelets is [length(fs),length(win)] = [length(fs),n];

% spec test frequency ranges:
tfs = sR*(0:(1/(2*scale)):.5);
tfsl = tfs(intersect(find(tfs>=(f-3*r)),find(tfs<=(f-2*r))));
tfsr = tfs(intersect(find(tfs>=(f+2*r)),find(tfs<=(f+3*r))));
tfs = [tfsl,tfsr];
testWavelets = complexGabor(tfs/sR,scale,0,win);

modulator = buildPowerModulator([zeros(1,2*n),x,zeros(1,2*n)],testWavelets,fs,tfs);

% Build the windowed signal array:
centers = (1+manualOffset):timeJump:N; % Interior centers.
leftCenters = centers(1);
centers = centers(2:end);
while round(leftCenters(1)) > -n2+1
    leftCenters = cat(2,leftCenters(1)-timeJump,leftCenters);
end
while round(leftCenters(end)) < n2
    leftCenters = cat(2,leftCenters,leftCenters(end)+timeJump);
    centers = centers(2:end);
end
rightCenters = centers(end);
centers = centers(1:end-1);
while round(rightCenters(end)) < N+n2
    rightCenters = cat(2,rightCenters,rightCenters(end)+timeJump);
end
while round(rightCenters(1)) > N-n2
    rightCenters = cat(2,rightCenters(1)-timeJump,rightCenters);
    centers = centers(1:end-1);
end
centers = round([leftCenters,centers,rightCenters]);
weights = scale/2*(erf(sqrt(pi)*(N-centers)/scale)-erf(sqrt(pi)*(1-centers)/scale))/scale;
weights = weights( 2:(end-1) );
centers = centers( 2:(end-1) );

% Pad x and y, initialize X (holder of signal sections on temporal support of atoms), and initizlize the power modulator:
x = [zeros(1,2*n),x,zeros(1,2*n)];
y = [zeros(1,2*n),y,zeros(1,2*n)];
X = zeros(length(centers),n);
pM = zeros(size(X,1),size(modulator,1)); % the power modulator

% Adjust the "centers" index to account for the padding by n
centers = centers + 2*n;

% Build X and the power modulator.
for jj = 1:length(centers)
    X(jj,:) = x((-n2:n2)+centers(jj));
    pM(jj,:) = mean(modulator(:,round( ((-scale/(2*rez)):(scale/(2*rez)))+centers(jj))),2)';
end

% Calculate phase and amplitude of fitted gabor atoms:
phase = -angle( X*wavelets.'); %[windowCount,length(fs)]
realWavelets = zeros(size(X,1),n,length(fs));
amplitude = zeros(size(phase));
for jj = 1:length(fs)
    % Compute the real wavelets.
    realWavelets(:,:,jj) = real(exp(1i*phase(:,jj))*wavelets(jj,:));  %[windowCount,1]*[1,n] = [windowCounts,n]
    % Modify the real wavelet amplitude by the power modulator.
    amplitude(:,jj) = sum(X.*squeeze(realWavelets(:,:,jj)),2)-pM(:,jj) ;
    % Set negative modified amplitudes to zero.
    amplitude(:,jj) = amplitude(:,jj).*(amplitude(:,jj) > 0);
end
% Find the best fit atom after power modulation.
[amps,whichFreq] = max(amplitude,[],2); % amps and whichFreq are [windowCount,1]


% Put the best fit atom into the the 1st instance of the 3rd index of
% realWavelets.
for jj = 1:size(X,1)
    realWavelets(jj,:,1) = realWavelets(jj,:,whichFreq(jj));
end
% Retain only the best fit atoms.
realWavelets = squeeze(realWavelets(:,:,1));

% Rescale atoms according to partition of unity.
realWavelets = bsxfun(@times,scalingFactor*amps./weights',realWavelets)*sqrt(2);

% Update x and y with computed realWavelets atoms:
for jj = 1:length(centers)
    x((-n2:n2)+centers(jj)) = x((-n2:n2)+centers(jj)) - realWavelets(jj,:);
    y((-n2:n2)+centers(jj)) = y((-n2:n2)+centers(jj)) + realWavelets(jj,:);
end
x = x((2*n+1):(end-2*n));
y = y((2*n+1):(end-2*n));

end

function modulator = buildPowerModulator(x,testDict,targetFreqs,testFreqs)

C = multiConvolveFFT(testDict,x);

CmodWeights = zeros(length(targetFreqs),length(testFreqs));

for kk = 1:length(targetFreqs)
    CmodWeights(kk,:) = targetFreqs(kk)-testFreqs;
end
CmodWeights = abs(1./CmodWeights);
CmodWeights = bsxfun(@times,CmodWeights,1./sum(CmodWeights,2));

modulator = sqrt(exp( CmodWeights*log(abs(C).^2) ));


end

function gaborFun = complexGabor(f,s,u,time)
% can output multiple gaborFuns: gaborFun is [p,n]
% time is [1,n]
% s,f are [1,p]
s = s'; % [p,1]
f = f'; % [p,1]
if ~isinf(s)
    g1 = bsxfun(@times,2^(1/4)/sqrt(s),exp(-pi/s^2*(time-u).^2));
%     goo = length(time)-(s+1);
%     g1 = [zeros(1,goo/2),dpss(s+1,3,1)',zeros(1,goo/2)];
    gaborFun = bsxfun(@times,g1,exp(1i*2*pi*f*(time-u)));
else
    gaborFun = exp(1i*2*pi*f*(time-u));
end
% gaborFun = bsxfun(@times,gaborFun,(1./sqrt(sum(abs(gaborFun.').^2)))');
% if f == 0
%     gaborFun = gaborFun./sqrt(2);
% end

end

function [C,varargout] = multiConvolveFFT(filters,y)
% filters are an [k,n] bank of functions, where n is length of each filter
% and k is the number of filters. y is a [1,N] signal vector.
% returns [k,N] (absolute value) convolutions.
% optionaly returns the phase, or argument, of the complex convolutions.

% pad = size(filters,2);
% nn = 3*pad+length(y)-1;
% yF = fft([zeros(1,pad),y,zeros(1,pad)],nn);
% fF = fft(filters,nn,2);
% C = ifft(bsxfun(@times,yF,fF),[],2);

% % Convolve left and right edges:
% n2 = ceil((size(filters,2)-1)/2);
% n = size(filters,2);
% yL = [-fliplr(y(1:n)),y(1:n)];
% yR = [y((end-n+1):end),-fliplr(y((end-n+1):end))];
% for ii = 1:n2
%     conL(:,ii) = sum(bsxfun(@times,filters,yL( (ii+n2):(ii+n2-1+n) )),2);
%     conR(:,ii) = sum(bsxfun(@times,filters,yR( (ii):(ii-1+n) )),2);
% end


    nn = size(filters,2) + length(y) ; % nn = n+N
    yF = fft(y,nn);
    fF = fft(filters,nn,2);
    C = ifft(bsxfun(@times,yF,fF),[],2);
    C = C(:,( floor(size(filters,2)/2+1) + (0:(length(y)-1)) ));
    
% C(:,1:n2) = conL;
% C(:,(end-n2+1):end) = conR;
    
    varargout{1} = angle(C);
    %C = abs(C);
    
end
