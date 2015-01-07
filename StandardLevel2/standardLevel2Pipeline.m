function [EEG, computationTimes] = standardLevel2Pipeline(EEG, params)

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
%                            and status written in EEG.etc.NoisyParameters
%   computationTimes         Time in seconds for each stage
%
% Additional setup:
%    EEGLAB should be in the path.
%    The EEG-Clean-Tools/StandardLevel2 directory and its subdirectories 
%    should be in the path.
%

%% Setup the output structures and set the input parameters
computationTimes= struct('resampling', 0, 'highPass', 0, ...
    'lineNoise', 0, 'reference', 0);
errorMessages = struct('status', 'good', 'boundary', 0, 'resampling', 0, ...
    'highPass', 0, 'lineNoise', 0, 'reference', 0);
pop_editoptions('option_single', false, 'option_savetwofiles', false);
if isfield(EEG.etc, 'noisyParameters')
    warning('EEG.etc.noisyParameters already exists and will be cleared\n')
end
if ~exist('params', 'var')
    params = struct();
end
if ~isfield(params, 'name')
    params.name = ['EEG' EEG.filename];
end
EEG.etc.noisyParameters = ...
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
        EEG.etc.noisyParameters.errors = errorMessages;
        return;
    end
end
%% Part I: Resampling
fprintf('Resampling\n');
try
    tic
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.noisyParameters.resampling = resampling;
    computationTimes.resampling = toc;
catch mex
    errorMessages.resampling = ...
        ['standardLevel2Pipeline failed resampleEEG: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noisyParameters.errors = errorMessages;
    return;
end

%% Part II: High pass filter
fprintf('High pass filtering\n');
try
    tic
    [EEG, highPass] = highPassFilter(EEG, params);
    EEG.etc.noisyParameters.highPass = highPass;
    computationTimes.highPass = toc;
catch mex
    errorMessages.highPass = ...
        ['standardLevel2Pipeline failed highPassFilter: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noisyParameters.errors = errorMessages;
    return;
end
   
%% Part III: Remove line noise
fprintf('Line noise removal\n');
try
    tic
    [EEG, lineNoise] = cleanLineNoise(EEG, params);
    EEG.etc.noisyParameters.lineNoise = lineNoise;
    computationTimes.lineNoise = toc;
catch mex
    errorMessages.lineNoise = ...
        ['standardLevel2Pipeline failed cleanLineNoise: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noisyParameters.errors = errorMessages;
    return;
end 
 
%% Part IV: Remove a robust reference
fprintf('Robust reference removal\n');
try
    tic
    [EEG, reference] = robustReference(EEG, params);
    EEG.etc.noisyParameters.reference = reference;
    computationTimes.reference = toc;
catch mex
    errorMessages.reference = ...
        ['standardLevel2Pipeline failed robustReference: ' ...
        getReport(mex, 'basic', 'hyperlinks', 'off')];
    errorMessages.status = 'unprocessed';
    EEG.etc.noisyParameters.errors = errorMessages;
    return;
end 
EEG.etc.noisyParameters.errors = errorMessages;
