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
okay = true;
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
end;

%% Pop up window
if nargin < 2
    userData = getUserData();
    [params, okay] = MasterGUI([],[],userData, EEG);
end

%% Return if user pressed cancel
if (~okay) 
	return;
end

%% Being the pipeline execution
userData = getUserData();
com = sprintf('%s = pop_prepPipeline(%s, %s);', inputname(1), ...
    struct2str(params));

reportMode = userData.report.reportMode.value;
consoleFID = userData.report.consoleFID.value;
publishOn = userData.report.publishOn.value;
summaryFilePath = userData.report.summaryFilePath.value;
sessionFilePath = userData.report.sessionFilePath.value;

if okay
    if strcmpi(reportMode, 'normal') || strcmpi(reportMode, 'skipReport')
        EEG = prepPipeline(EEG, params);
    end
    if (strcmpi(reportMode, 'normal') || ...
            strcmpi(reportMode, 'reportOnly')) %&& publishOn
        publishPrepReport(EEG, summaryFilePath, sessionFilePath, ...
            consoleFID, publishOn);
    end
    if strcmpi(reportMode, 'normal') || strcmpi(reportMode, 'skipReport')
        EEG = prepPostProcess(EEG, params);
    end
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

end % pop_prepPipeline