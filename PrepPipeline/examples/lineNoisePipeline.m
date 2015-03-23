function [EEG1, EEG2, computationTimes] = lineNoisePipeline(EEG, params)
% Run filtering and line noise removal on EEG and return in EEG1 and EEG2
% 
% Input parameters:
%  EEG                       An EEGLAB structure with the data and chanlocs
%  params                    A structure with at least the following:
%
%     name                   A string with a name identifying dataset
%                            [default: EEG.setname]
%     lineFrequencies        A list of line frequencies to be removed
%                            [default: 60, 120, 180, 240]
%  
% Prep allows many other parameters to be over-ridden, but is meant to
% be used in a fully automated fashion.
%
% Output parameters:
%   EEG1                     An EEGLAB structure with the data high-passed
%   EEG2      
%   computationTimes         Time in seconds for each stage
%
% Additional setup:
%    EEGLAB should be in the path.
%    The EEG-Clean-Tools/PrepPipeline directory and its subdirectories 
%    should be in the path.
%
% Author:  Kay Robbins, UTSA, March 2015
%
% Full documentation is available in a user manual distributed with this
% source.

%% Setup the output structures and set the input parameters
computationTimes= struct('resampling', 0, 'globalTrend', 0,  ...
    'lineNoise', 0, 'reference', 0);
errorMessages = struct('status', 'good', 'boundary', 0, 'resampling', 0, ...
    'globalTrend', 0, 'detrend', 0, 'lineNoise', 0, 'reference', 0);
pop_editoptions('option_single', false, 'option_savetwofiles', false);
if isfield(EEG.etc, 'noiseDetection')
    warning('EEG.etc.noiseDetection already exists and will be cleared\n')
end
if ~exist('params', 'var')
    params = struct();
end
if ~isfield(params, 'name')
    params.name = ['EEG' EEG.filename];
end
EEG.etc.noiseDetection = ...
       struct('name', params.name, 'version', getPrepPipelineVersion, ...
              'errors', []);
%% Check for boundary events
try
    defaults = getPipelineDefaults(EEG, 'boundary');
    [boundaryOut, errors] = checkDefaults(params, struct(), defaults);
    if ~isempty(errors)
        error('boundary:BadParameters', ['|' sprintf('%s|', errors{:})]);
    end
    EEG.etc.noiseDetection.boundary = boundaryOut;
    if ~boundaryOut.ignoreBoundaryEvents && ...
            isfield(EEG, 'event') && ~isempty(EEG.event)
        eTypes = find(strcmpi({EEG.event.type}, 'boundary'));
        if ~isempty(eTypes)
            error(['Dataset ' params.name  ...
                ' has boundary events: [' getListString(eTypes) ...
                '] which are treated as discontinuities unless set to ignore']);
        end
    end
catch mex
    errorMessages.boundary = ...
        ['prepPipeline bad boundary events: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end

%% Part I: Resampling
fprintf('Resampling\n');
try
    tic
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.noiseDetection.resampling = resampling;
    computationTimes.resampling = toc;
catch mex
    errorMessages.resampling = ...
        ['prepPipeline failed resampleEEG: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end

%% Part II:  HP the signal for detecting bad channels
fprintf('Preliminary detrend to compute reference\n');
try
    tic
    [EEG1, detrend] = removeTrend(EEG, params);
    EEG1.etc.noiseDetection.detrend = detrend;
    computationTimes.detrend = toc;
catch mex
    errorMessages.removeTrend = ...
        ['prepPipeline failed removeTrend: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG1.etc.noiseDetection.errors = errorMessages;
    return;
end
 
%% Part III: Remove line noise
fprintf('Line noise removal\n');
try
    tic
    [EEG2, lineNoise] = cleanLineNoise(EEG1, params);
    EEG2.etc.noiseDetection.lineNoise = lineNoise;
    computationTimes.lineNoise = toc;
catch mex
    errorMessages.lineNoise = ...
        ['prepPipeline failed cleanLineNoise: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG2.etc.noiseDetection.errors = errorMessages;
    return;
end 

