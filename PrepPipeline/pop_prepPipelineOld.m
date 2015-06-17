% pop_prepPipeline() - runs the early stage pipeline to reference and to
% detect bad channels
%
% Usage:
%   >>   [OUTEEG, com] = pop_prepPipeline(INEEG, params);
%
% Inputs:
%   INEEG   - input EEG dataset
%   params  - structure with parameters to override defaults
%    
% Outputs:
%   OUTEEG  - output dataset
%
% See also:
%   prepPipeline, prepPipelineReport, EEGLAB 

% Copyright (C) 2015  Kay Robbins with contributions from Nima
% Bigdely-Shamlo, Christian Kothe, Tim Mullen, and Cassidy Matousek
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function [EEG, com] = pop_prepPipeline(EEG, params)
    com = ''; % Return something if user presses the cancel button
    if nargin < 1  %% display help if not enough arguments
        help pop_prepPipeline;
        return;
    elseif nargin < 2
        params = struct();
    end
    
    %% Add path to prepPipeline subdirectories if not in the list
    tmp = which('getPipelineDefaults');      
    if isempty(tmp)
        myPath = fileparts(which('prepPipeline'));
        addpath(genpath(myPath));
    end;

    %% Set up the default userData
    userData = struct('boundary', [], 'resample', [], ...
        'globalTrend', [], 'detrend', [], 'lineNoise', [], ...
        'reference', []);
    stepNames = fieldnames(userData);
    for k = 1:length(stepNames)
       defaults = getPipelineDefaults(EEG, stepNames{k});
       [theseValues, errors] = checkStructureDefaults(params, defaults);
       if ~isempty(errors)
          error('pop_prepPipeline:BadParameters', ['|' ...
                sprintf('%s|', errors{:})]);
       end
       userData.(stepNames{k}) = theseValues;
    end
    
    %% pop up window
    if nargin < 2
        geometry = {1, [1, 1], [1, 1], [1, 1]};
        geomvert = [];
        theName = 'EEG Clean Tools Main Menu';
        inputData = struct('signal', EEG, 'name', theName, 'userData', userData);
        closeOpenWindows(inputData.name);
        uilist= {{'style', 'text', 'string', 'Override default parameters for processing step:'}...
            {'style', 'pushbutton', 'string', 'Boundary', ...
             'Callback', {@boundaryGUI, inputData}} ...
            {'style', 'pushbutton', 'string', 'Resample', ...
             'Callback', {@resampleGUI, inputData}}...
            {'style', 'pushbutton', 'string', 'Global Trend', ...
             'Callback', {@globalTrendGUI, inputData}}...
            {'style', 'pushbutton', 'string', 'Detrend', ...
             'Callback', {@detrendGUI, inputData}}...
            {'style', 'pushbutton', 'string', 'Line Noise', ...
             'Callback', {@lineNoiseGUI, inputData}}...
            {'style', 'pushbutton', 'string', 'Reference', ...
             'Callback', {@referenceGUI, inputData}}};
        [~, userdata] = inputgui('geometry', geometry, 'geomvert', geomvert, ...
            'uilist', uilist, 'title', theName, ...
            'helpcom', 'pophelp(''pop_prepPipeline'')');
       
        params = struct();
        fNames = fieldnames(userdata);
        for k = 1:length(fNames)
            nextStruct = userdata.(fNames{k});
            nextNames = fieldnames(nextStruct);
            for j = 1:length(nextNames)
                params.(nextNames{j}) = nextStruct.(nextNames{j});
            end
        end
        com = sprintf('pop_prepPipeline(%s, %s);', inputname(1));
    else 
        com = sprintf('pop_prepPipeline(%s, %s);', inputname(1), inputname(2));
    end
    
    EEG = prepPipeline(EEG, params);
end

