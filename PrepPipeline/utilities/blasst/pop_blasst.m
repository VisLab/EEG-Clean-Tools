function [EEG,com] = pop_blasst(EEG,lineFrequencies,frequencyRanges,varargin)
% pop_blasst(): EEGLAB helper function for blasst filtering.
% Takes as input an EEGLAB EEG struct, along with relevant parameters, and
% calls blasst() for BLASST fitlering at specified frequencies. For each
% specified frequency, blasst() iteratively calls blasst_internal() and 
% then uses blasst_test() to test for convergence based on the 
% distributions of convolution coefficients in the target and surrounding 
% frequency bands.
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

com = '';

if nargin < 1
    help pop_blasst;
    return
end
if ~isfield(EEG,'data')
    error('Must specify signal(s) in EEG struct as: \n >>EEG.data = <signals>;')
elseif isempty(EEG.data)
    error('We can not BLASST nothing! EEG.data is empty.');
end

if isempty(lineFrequencies)
    error('BLASST requires input target frequencies.');
end

if isempty(frequencyRanges)
    error('BLASST requires input frequency ranges.');
end

if ~isfield(EEG,'srate')
    error('Must specify sampling rate in input EEG struct as: \n >>EEG.srate = <sampling rate>;')
elseif isempty(EEG.srate)
    error('BLASST must have a sampling rate! EEG.srate is empty.')
end

EEG.data = blasst(EEG.data,lineFrequencies,frequencyRanges,EEG.srate,varargin);
foo = [];
% Process varargin cell into string of name value pairs.
if ~isempty(varargin)
    if ~rem(length(varargin),2)
        foo = ',';
        if ischar(varargin{2})
            foo = [foo,'''',varargin{1}, ''', ''',varargin{2},''''];
        else
            foo = [foo,'''',varargin{1}, ''', ',num2str(varargin{2})];
        end
        for ii = 3:2:length(varargin);
            if ischar(varargin{ii+1})
                foo = [foo, ', ''', varargin{ii}, ''', ''', varargin{ii+1},''''];
            else
                foo = [foo, ', ''', varargin{ii}, ''', ', num2str(varargin{ii+1})];
            end
        end
%         foo = [foo,' }'];
    else
        error('Name value pairs do not match.')
    end
end

com = sprintf('%s = pop_blasst(%s,%s,%s%s);',inputname(1),inputname(1),mat2str(lineFrequencies),mat2str(frequencyRanges),foo);



end
