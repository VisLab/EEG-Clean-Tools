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
    'globalTrend', [], 'reference', [], 'detrend', [], ...
    'report', [], 'lineNoise', [], 'postProcess', []);
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
    [params, okay] = MasterGUI(userData, EEG);
    if okay
        com = createComStr(params);
        EEG = prepPipeline(EEG, params);
        [publishOn, sFold, sname, rFold, rname] = ...
            getReportArguments(params, userData);
        publishReport(publishOn, sFold, sname, rFold, rname);
    end
else
    com = createComStr(params);
    EEG = prepPipeline(EEG, params);
    [publishOn, sFold, sname, rFold, rname] = ...
        getUserDataReport(userData);
    publishReport(publishOn, sFold, sname, rFold, rname);
end

    function com = createComStr(params)
        % Creates a command string based on the parameters passed in
        paramStr = struct2str(params);
        com = sprintf('pop_prepPipeline(%s, %s);', inputname(1), paramStr);
    end % createParamStr

    function [publishOn, sFold, sname, rFold, rname] = ...
            getReportArguments(params, userData)
        % Gets the report argument values
        if ~isempty(params) && isfield(params, 'publishOn')
            [publishOn, sFold, sname, rFold, rname] = ...
                getParamReport(params);
        else
            [publishOn, sFold, sname, rFold, rname] = ...
                getUserDataReport(userData);
        end
    end % getReportArguments

    function [publishOn, sFold, sname, rFold, rname] = ...
            getParamReport(params)
        % Gets the report argument values from the user parameters
        publishOn = params.publishOn;
        sFold = params.summaryFolder;
        sname = params.summaryName;
        rFold = params.reportFolder;
        rname = params.reportName;
    end % getParamReportArguments

    function [publishOn, sFold, sname, rFold, rname] = ...
            getUserDataReport(userData)
        % Gets the report argument values from the default user data
        publishOn = userData.report.publishOn.value;
        sFold = userData.report.summaryFolder.value;
        sname = userData.report.summaryName.value;
        rFold = userData.report.reportFolder.value;
        rname = userData.report.reportName.value;
    end % getUserDataReportArguments

    function publishReport(publishOn, sFold, sname, rFold, rname)
        % If publishOn is true, then publish the report
        if publishOn
            consoleFID = 1;
            publishPrepReport(EEG, sFold, sname, ...
                rFold, rname, consoleFID, publishOn);
        end
    end % publishReport

end % pop_prepPipeline