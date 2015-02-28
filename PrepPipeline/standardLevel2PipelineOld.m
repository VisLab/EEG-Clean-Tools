function [EEG, computationTimes] = standardLevel2PipelineOld(EEG, params)

%% Standard level 2 pipeline 
% This assumes the following have been set:
%  EEG                       An EEGLAB structure with the data and chanlocs
%  params                    A structure with at least the following:
%
%     name                   A string with a name identifying dataset
%     referenceChannels      A vector of channels to be used for
%                            rereferencing (Usually these are EEG (no
%                            mastoids or EOG)
%     rereferencedChannels   A vector of channels to be high-passed, 
%                            line-noise removed, and referenced. 
%     lineFrequencies        A list of line frequencies
%  
%
% Returns:
%   EEG                      An EEGLAB structure with the data processed
%                            and status written in EEG.etc.noiseDetection
%   computationTimes         Time in seconds for each stage
%
% Additional setup:
%    EEGLAB should be in the path.
%    The EEG-Clean-Tools/StandardLevel2 directory and its subdirectories 
%    should be in the path.
%

%% Setup the output structures and set the input parameters
computationTimes= struct('resampling', 0, 'detrend', 0, ...
    'lineNoise', 0, 'reference', 0);
errorMessages = struct('status', 'good', 'boundary', 0, 'resampling', 0, ...
    'detrend', 0, 'lineNoise', 0, 'reference', 0);
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
       struct('name', params.name, 'version', getStandardLevel2Version, ...
              'errors', []);
%% Check for boundary events
noisyOut.ignoreBoundaryEvents = ...
    getStructureParameters(params, 'ignoreBoundaryEvents', false);
if ~noisyOut.ignoreBoundaryEvents && ...
                isfield(EEG, 'event') && ~isempty(EEG.event)
    eTypes = find(strcmpi({EEG.event.type}, 'boundary'));
    if ~isempty(eTypes)
        errorMessages.status = 'unprocessed';
        errorMessages.boundary = ['Dataset ' params.name  ...
            ' has boundary events: [' getListString(eTypes) ...
            '] which are treated as discontinuities unless set to ignore'];    
        EEG.etc.noiseDetection.errors = errorMessages;
        return;
    end
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
        ['standardLevel2Pipeline failed resampleEEG: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end

%% Part II: Detrend or high pass filter
fprintf('Detrending\n');
try
    tic
    [EEG, trend] = removeTrend(EEG, params);
    EEG.etc.noiseDetection.detrend = trend;
    computationTimes.detrend = toc;
catch mex
    errorMessages.removeTrend = ...
        ['standardLevel2Pipeline failed removeTrend: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end
%% Part III: Remove line noise
fprintf('Line noise removal\n');
try
    tic
    [EEG, lineNoise] = cleanLineNoise(EEG, params);
    EEG.etc.noiseDetection.lineNoise = lineNoise;
    computationTimes.lineNoise = toc;
catch mex
    errorMessages.lineNoise = ...
        ['standardLevel2Pipeline failed cleanLineNoise: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end 
 
%% Part IV: Remove reference
fprintf('Reference removal\n');
try
    tic
    [EEG, reference] = performReference(EEG, params);
    EEG.etc.noiseDetection.reference = reference;
    computationTimes.reference = toc;
catch mex
    errorMessages.reference = ...
        ['standardLevel2Pipeline failed performReference: ' ...
        getReport(mex, 'basic', 'hyperlinks', 'off')];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end 
EEG.etc.noiseDetection.errors = errorMessages;
