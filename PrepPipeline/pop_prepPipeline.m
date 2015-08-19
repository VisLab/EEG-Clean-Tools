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
userData = struct('boundary', [], 'detrend', [], ...
    'lineNoise', [], 'reference', [], ...
    'report', [],  'postProcess', []);
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
    [params, okay] = MasterGUI([],[],userData, EEG);
    if okay
        com = createComStr(params);
        [reportMode, publishOn, sFold, sname, rFold, rname] = ...
            getReportArguments(params, userData);
    end
else
    com = createComStr(params);
    okay = true;
    [reportMode, publishOn, sFold, sname, rFold, rname] = ...
        getUserDataReport(userData);
end

if okay
    if strcmpi(reportMode, 'normal') || strcmpi(reportMode, 'skipReport')
        EEG = prepPipeline(EEG, params);
    end
    if strcmpi(reportMode, 'normal') || strcmpi(reportMode, 'reportOnly')
        publishReport(publishOn, sFold, sname, rFold, rname);
    end
end

%%---JEREMY --- need to get postprocessing arguments here. Then I can write
% The parameters are:
%  removeInterpolationChannels, cleanUpReference, keepFiltering
%%---Professor Robbins--- here are the parameters
if okay
    [cleanUpReference, keepFiltered, removeInterChan] = ...
        getPostProcessArguments(params, userData);
end

    function com = createComStr(params)
        % Creates a command string based on the parameters passed in
        paramStr = struct2str(params);
        com = sprintf('pop_prepPipeline(%s, %s);', inputname(1), paramStr);
    end % createParamStr

    function [cleanUpReference, keepFiltered, removeInterChan] = ...
            getPostProcessArguments(params, userData)
        % Gets the post process argument values
        if ~isempty(params) && isfield(params, 'keepFiltered')
            [cleanUpReference, keepFiltered, removeInterChan] = ...
                getParamPostProcess(params);
        else
            [cleanUpReference, keepFiltered, removeInterChan] = ...
                getUserDataPostProcess(userData);
        end
    end % getPostProcessArguments

    function [reportMode, publishOn, sFold, sname, rFold, rname] = ...
            getReportArguments(params, userData)
        % Gets the report argument values
        if ~isempty(params) && isfield(params, 'publishOn')
            [reportMode, publishOn, sFold, sname, rFold, rname] = ...
                getParamReport(params);
        else
            [reportMode, publishOn, sFold, sname, rFold, rname] = ...
                getUserDataReport(userData);
        end
    end % getReportArguments

    function [cleanUpReference, keepFiltered, removeInterChan] = ...
            getParamPostProcess(params)
        % Gets the post process argument values from the user parameters
        cleanUpReference = params.cleanUpReference;
        keepFiltered = params.keepFiltered;
        removeInterChan = params.removeInterChan;
    end % getParamPostProcess

    function [reportMode, publishOn, sFold, sName, rFold, rName] = ...
            getParamReport(params)
        % Gets the report argument values from the user parameters
        reportMode = params.reportMode;
        publishOn = params.publishOn;
        sFold = params.summaryFolder;
        sName = params.summaryName;
        rFold = params.reportFolder;
        rName = params.reportName;
    end % getParamReport

    function [cleanUpReference, keepFiltered, removeInterChan] = ...
            getUserDataPostProcess(userData)
        % Gets the post process argument values from the default user data
        cleanUpReference = userData.postProcess.cleanUpReference.value;
        keepFiltered = userData.postProcess.keepFiltered.value;
        removeInterChan = userData.postProcess.removeInterChan.value;
    end % getUserDataPostProcess

    function [reportMode, publishOn, sFold, sName, rFold, rName] = ...
            getUserDataReport(userData)
        % Gets the report argument values from the default user data
        reportMode = userData.report.reportMode.value;
        publishOn = userData.report.publishOn.value;
        sFold = userData.report.summaryFolder.value;
        sName = userData.report.summaryName.value;
        rFold = userData.report.reportFolder.value;
        rName = userData.report.reportName.value;
    end % getUserDataReport

    function publishReport(publishOn, sFold, sName, rFold, rName)
        % If publishOn is true, then publish the report
        if publishOn
            consoleFID = 1;
            publishPrepReport(EEG, sFold, sName, ...
                rFold, rName, consoleFID, publishOn);
        end
    end % publishReport

end % pop_prepPipeline