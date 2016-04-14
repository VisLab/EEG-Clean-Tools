function [BDist,maxFlag,varargout] = blasst_test(x,f,r,sR,scale)
% blasst_test(): Tests for convergence of the BLASST line noise removal
% approach by comparing the Bhattahcharya distance between the target and
% test frequency bands.
%
% INPUT:
% x     is [1,N] time series signal.
% f     is the target frequency (a scalar, NOT normalized) ex. 60 for 60 Hz
% r     is the target frequency range within which we seek to remove noise.
%       For example, if line noise is not stationary, we might seek to
%       remove noise between 57 and 63 Hz, in which case r = 3.
% sR    is the sampling rate of the signal.
% scale is the scale of Gabor atoms to be compared.
%
% OUTPUT:
% BDist is the Bhattacharya distance between the weighted average 
%       probability distributions of the test and target bands.
% maxFlag       is a flag that specifies whether or not the target
%               distribution is trivially way to the right of the test.
%               Helps to avoid numerical errors in convergence at early
%               iterations of OCW_LNR.
% varargout{1}  is a struct with fields:
%   'CHists'    is the the probability distributions of the target
%               spectral band.
%   'DHists'    is the the probability distributions of the test spectral 
%               band.
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

N = size(x,2);
n2 = scale*2; % half-window length
win = (-n2):(n2);

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

C = multiConvolveFFT(wavelets,x);
D = multiConvolveFFT(testWavelets,x);

testWeights = zeros(length(fs),length(tfs)); %[targetFrequencies,testFrequencies]
for kk = 1:length(fs)
    testWeights(kk,:) = fs(kk)-tfs;
end
testWeights = abs(1./testWeights);
testWeights = bsxfun(@times,testWeights,1./sum(testWeights,2));

D = abs(D);
C = abs(C); % Now C and D are real and same size: [

binCount = ceil(2*N^(1/3));
[DHists,centers] = hist(log((abs(D).^2)'),binCount); %[binCount,lenegth(tfs)] vectors
DHists = DHists/N;

DCompare = mean(DHists*testWeights',2);
CHists = hist(log((abs(C).^2)'),centers);
CHists = CHists/N;
CCompare = mean(CHists,2);

[~,CMaxInd] = max(CCompare);
if CMaxInd == binCount % Presumably, CCompare distribution is somewhat skewed to the right and we are nowhere near convergence.
    maxFlag = 1;
else
    maxFlag = 0;
end

BDist = -log(sum(sqrt(DCompare.*CCompare))+1e-8);
varargout{1}.CHist = CHists;
varargout{1}.DHist = DHists;
varargout{1}.CCompare = CCompare;
varargout{1}.DCompare = DCompare;
varargout{1}.centers = centers;


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

end

function [C,varargout] = multiConvolveFFT(filters,y)
% filters are an [k,n] bank of functions, where n is length of each filter
% and k is the number of filters. y is a [1,N] signal vector.
% returns [k,N] (absolute value) convolutions.
% optionaly returns the phase, or argument, of the complex convolutions.
    nn = size(filters,2) + length(y); % nn = n+N
    yF = fft(y,nn);
    fF = fft(filters,nn,2);
    C = ifft(bsxfun(@times,yF,fF),[],2);
    C = C(:,( floor(size(filters,2)/2+1) + (0:(length(y)-1)) ));
    varargout{1} = angle(C);
    
end
