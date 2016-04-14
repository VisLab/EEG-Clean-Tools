function [x,varargout] = blasst(x,lineFrequencies,frequencyRanges,samplingRate,varargin)
% blasst(): EEGLAB helper function for OCW line noise removal.
% Takes as input an array of signals x, along with relevant parameters, and
% performs BLASST filtering at specified frequencies. For each specified 
% frequency, blasst() iteratively calls blasst_internal() and then uses
% blasst_test() to test for convergence based on the distributions of
% convolution coefficients in the target and surrounding frequency bands.
%
% INPUT:
% x                 an [n,N] array of n signals of length N.
% lineFrequencies   an array of target frequencies (not normalized).
% frequenyRanges    an array of target frequency ranges. Must be the same
%                   size as lineFrequencies.
% samplingRate      the sampling rate of the signal.
% varargin          optional 'key',value pairs:
%   'key'           
%           [default] purpose
%   'Scale'        
%           [2^(log2(samplingRate)+2)] Manually set the scale that 
%           indicates the spread of Gabor atoms.
%   'ContinuousEpochs'  
%           [0] If x is epoched, but epochs are temporally adjacent, 
%           setting to 1 will flatten x for processing. Otherwise, 
%           blasst is run on individual epochs.
%   'Verbose'
%           [1] When on, progress is printed on command line.
%   'Resolution'
%           [2] May be an integer value >= 1, sets 'resolution' in blasst.
%           Specificies density of Gabor atoms. May also be an array of
%           integer values of size(lineFrequencies).
%   'MaxIterations'
%           [50] Maximum number of external iterations of blasst run on
%           each frequency. May be either a scalar integer or array of
%           integers of size(lineFrequencies).
%   'ManualOffset'
%           [log2(scaleBases)+1] A scalar value that offsets the 
%           arrangement of Gabor atoms at each iteration of blasst.
%   'Channels'
%           [1:size(x,1)] An array of integers indexing channels to
%           be computed. Allows manually selection of channels for
%           processing.
%
% OUTPUT:
% x                 the processed, or ``cleaned'' signal.
% varargout{1}      the aggregate of the target signal feature removed, an 
%                   array of size(x).
%
% DEPENDENCIES:
% blasst_internal()         primary line noise removal algorithm.
% blasst_test()        convergence test for iterative blasst algorithm.
%
% EXAMPLE:
%  Suppose we wish to remove line noise frequency at 60 and 120 Hz, and the
%  noise is mostly stationary at 120 Hz but non-stationary varying by about
%  2 Hz, around 60 Hz. Then we might call the method as:
% >> x = blasst(x,[60,120],[2,.25],<sampling rate>);
%
%  If we want to use more densely packed Gabor atoms, we could call:
% >> x = blasst(x,[60,120],[2,.25],<sampling rate>,'Resolution',4);
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

% Set defaults:
flattenData = 0;
verbose = 1;
resolution = 2;
maxIterations = 50; % Default is high so that the method generally will generally converge.
channels = 1:size(x,1);

% Adjust for optional inputs
if (nargin> 1)
    if (nargin> 4 && rem(nargin,2) == 1)
        if length(varargin) == 1
            varargin = varargin{1};
        else
            fprintf('blasst(): Optional key and value pairs do not match.')
            return
        end
    end
    
    for ii = 1:2:length(varargin)
        key = varargin{ii};
        val = varargin{ii+1};
        switch key
            case 'SamplingRate'
                samplingRate = val;
            case 'Scale'
                scale = val;
            case 'ContinuousEpochs'
                flattenData = val;
            case 'Verbose'
                verbose = val;
            case 'Resolution'
                resolution  = val;
            case 'MaxIterations'
                maxIterations = val;
            case 'ManualOffset'
                manualOffset = val;
            case 'Channels'
                channels = val;
        end
    end
end

if length(frequencyRanges) == 1
    frequencyRanges = ones(size(lineFrequencies))*frequencyRanges;
elseif length(frequencyRanges) ~= length(lineFrequencies)
    error('Number of specified noise frequencies does not match number of specified range values.');
end

if length(resolution) == 1
    resolution = ones(size(lineFrequencies))*resolution;
elseif length(resolution) ~= length(lineFrequencies)
    error('Number of specified noise resolutions does not match number of specified range values.');
end

if length(maxIterations) == 1
    maxIterations = ones(size(lineFrequencies))*maxIterations;
elseif length(maxIterations) ~= length(lineFrequencies)
    error('Number of specified max iterations does not match number of specified range values.');
end

if ~exist('samplingRate','var')
    error('No sampling rate specified.');
elseif isempty(samplingRate) || samplingRate == 0
    error('Null or zero sampling rate specified.');
end

if ~exist('scaleBases','var')
    scale = 2^(log2(samplingRate)+2);
end

if ~exist('manualOffset','var')
    manualOffset = log2(scale)+1;
end

if flattenData
    dataSizeTemp = size(x);
    x = reshape(x,size(x,1),size(x,2)*size(x,3));
end

% Initialize holders for fitted noise and cleaned signals.
y = zeros(size(x));
yTemp = zeros(size(x));
xTemp = zeros(size(x));

countTrack = 1;

for ii = 1:length(lineFrequencies)
    
    if verbose
        fprintf(1,'Frequency: %d Hz\n',lineFrequencies(ii));
    end
    for jj = channels
        if verbose
            fprintf(1,'Computing Channel:                ');
        end
        %         BDist = Inf;
        [BDist,~,~] = blasst_test(reshape(x(jj,:,:),1,size(x,2)*size(x,3)),lineFrequencies(ii),frequencyRanges(ii),samplingRate,scale);
        for mm = 1:maxIterations(ii)
            if verbose
                fprintf(1,'\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b% 3i   Pass: % 3i',jj,mm);
            end
            % Run blasst_internal for each epoch of data in the EEG struct.
            for kk = 1:size(x,3)
                [yTemp(jj,:,kk),xTemp(jj,:,kk)] = blasst_internal(x(jj,:,kk),lineFrequencies(ii),frequencyRanges(ii),samplingRate,scale,resolution(ii),(mm-1)*manualOffset);
                %                 y(jj,:,kk) = y(jj,:,kk) + tempY;
                %                 EEG.data(jj,:,kk) = tempX;
            end
            
            % Compute Bhatt. distance for testing convergence. Overwrite
            % BDist1, then compare to BDist (from the last pass). If BDist1
            % exceeds BDist, we presume we have passed the minimum distance
            % between the distributions, and we should halt the algorithm
            % for this channel and frequency, retaining only previous
            % passes.
            
            [BDist1,maxFlag,~] = blasst_test(reshape(xTemp(jj,:,:),1,size(xTemp,2)*size(xTemp,3)),lineFrequencies(ii),frequencyRanges(ii),samplingRate,scale);
            countTrack = countTrack+1;
            if BDist1 >= BDist && ~maxFlag % && mm > 1
                if verbose
                    fprintf(1,'\nBreak at pass % 2i\n',mm-1);
                end
                break
            else
                BDist = BDist1;
                y(jj,:,:) = y(jj,:,:) + yTemp(jj,:,:);
                x(jj,:,:) = xTemp(jj,:,:);
            end
        end
        if verbose
            fprintf(1,'\n');
        end
    end
    if verbose
        fprintf(1,'\n');
    end
    
end

varargout{1} = y; % This is the aggregate of all line noise that was removed. That is, y+EEG.data is the original dataset.

if flattenData
    x = reshape(x,dataSizeTemp(1),dataSizeTemp(2),dataSizeTemp(3));
end

end
