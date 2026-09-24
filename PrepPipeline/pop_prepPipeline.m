% pop_prepPipeline() - runs the early stage pipeline to reference and to
% detect bad channels
%
% Usage:
%   >>   [OUTEEG, com] = pop_prepPipeline(INEEG, params);
%
% Inputs:
%   INEEG   - input EEG dataset
%   params  - (optional) structure with parameters to override defaults
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
tmp = which('getPrepDefaults');
if isempty(tmp)
    myPath = fileparts(which('prepPipeline'));
    addpath(genpath(myPath));
end

%% Pop up window
userData = getUserData();
if nargin < 2
    params = MasterGUI([],[],userData, EEG);
end

%% Begin the pipeline execution
paramsUpdated = updateParams(params);
com = sprintf('%s = pop_prepPipeline(%s, %s);', inputname(1), ...
    struct2str(paramsUpdated));

options = getReportOptions(userData, paramsUpdated);

if strcmpi(options.reportMode, 'normal') || strcmpi(options.reportMode, 'skipReport')
    EEG = prepPipeline(EEG, paramsUpdated);
end

%% Handle reporting
if (strcmpi(options.reportMode, 'normal') || strcmpi(options.reportMode, 'reportOnly'))
    publishPrepReport(EEG, options.summaryFilePath, options.sessionFilePath, ...
        options.consoleFID, options.publishOn);
end

%% Perform post-processing
if strcmpi(options.reportMode, 'normal') || strcmpi(options.reportMode, 'skipReport')
    EEG = prepPostProcess(EEG, paramsUpdated);
end

    function userData = getUserData()
        %% Gets the userData defaults and merges it with the parameters
        userData = struct('boundary', [], 'detrend', [], ...
            'lineNoise', [], 'reference', [], ...
            'report', [],  'postProcess', []);
        stepNames = fieldnames(userData);
        for k = 1:length(stepNames)
            defaults = getPrepDefaults(EEG, stepNames{k});
            [theseValues, errors] = checkStructureDefaults(params, ...
                defaults);
            if ~isempty(errors)
                error('pop_prepPipeline:BadParameters', ['|' ...
                    sprintf('%s|', errors{:})]);
            end
            userData.(stepNames{k}) = theseValues;
        end
    end  % getUserData

    function paramsOut = updateParams(userDataUpdate)
        paramsOut = struct();
        if ~isempty(userDataUpdate)
            fNames = fieldnames(userDataUpdate);
            for k = 1:length(fNames)
                nextStruct = userDataUpdate.(fNames{k});
                nextNames = fieldnames(nextStruct);
                for j = 1:length(nextNames)
                    paramsOut.(nextNames{j}) = nextStruct.(nextNames{j});
                end
            end
        end
    end

    function options = getReportOptions(userData, paramsUpdated)
        options = struct('reportMode', '', 'consoleFID', '', 'publishOn', '', ...
                         'summaryFilePath', '', 'sessionFilePath', '' );
        options.reportMode = userData.report.reportMode.value;
        if isfield(paramsUpdated, 'reportMode')
            options.reportMode = paramsUpdated.reportMode;
        end
        options.consoleFID = userData.report.consoleFID.value;
        if isfield(paramsUpdated, 'consoleFID')
            options.consoleFID = paramsUpdated.consoleFID;
        end
        
        options.publishOn = userData.report.publishOn.value;
        if isfield(paramsUpdated, 'publishOn')
            options.publishOn = paramsUpdated.publishOn;
        end
        
        options.summaryFilePath = userData.report.summaryFilePath.value;
        if isfield(paramsUpdated, 'summaryFilePath')
            options.summaryFilePath = paramsUpdated.summaryFilePath;
        end
        options.summaryFilePath = resolvePath(options.summaryFilePath);
        
        options.sessionFilePath = userData.report.sessionFilePath.value;
        if isfield(paramsUpdated, 'sessionFilePath')
            options.sessionFilePath = paramsUpdated.sessionFilePath;
        end
        options.sessionFilePath = resolvePath(options.sessionFilePath);
        
        fprintf('summaryFilePath: %s\n', options.summaryFilePath)
        fprintf('sessionFilePath: %s\n', options.sessionFilePath)
    end

    function absPath = resolvePath(pathIn)
         if isfolder(pathIn) || isfile(pathIn)
        % Already exists, maybe absolute
        absPath = fullfile(pathIn);
    else
        % Assume relative to current folder
        absPath = fullfile(pwd, pathIn);
    end
end

end % pop_prepPipeline