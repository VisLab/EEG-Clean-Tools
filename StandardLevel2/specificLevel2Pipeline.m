function [EEG, computationTimes] = specificLevel2Pipeline(EEG, params)

%% Specific level 2 pipeline 
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
computationTimes= struct('resampling', 0, 'highPass', 0, ...
    'lineNoise', 0, 'reference', 0);
errorMessages = struct('status', 'good', 'resampling', 0, ...
    'highPass', 0, 'lineNoise', 0, 'reference', 0);
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

%% Part I: Resampling
fprintf('Resampling\n');
try
    tic
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.noiseDetection.resampling = resampling;
    computationTimes.resampling = toc;
catch mex
    errorMessages.resampling = ...
        ['specificLevel2Pipeline failed resampleEEG: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end

%% Part II: High pass filter
fprintf('High pass filtering\n');
try
    tic
    [EEG, highPass] = highPassFilter(EEG, params);
    EEG.etc.noiseDetection.highPass = highPass;
    computationTimes.highPass = toc;
catch mex
    errorMessages.highPass = ...
        ['specificLevel2Pipeline failed highPassFilter: ' getReport(mex)];
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
        ['specificLevel2Pipeline failed cleanLineNoise: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end 
% fn = ['N:\\ARLAnalysis\\VEPStandardLevel2L\\temp\\' params.name];
% save(fn, 'EEG', '-v7.3');
%% Part IV: Remove a average reference
fprintf('Average reference removal\n');
try
    tic
    [EEG, reference] = specificReference(EEG, params);
    EEG.etc.noiseDetection.reference = reference;
    computationTimes.reference = toc;
catch mex
    errorMessages.reference = ...
        ['specificLevel2Pipeline failed ordinaryReference: ' ...
        getReport(mex, 'basic', 'hyperlinks', 'off')];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end 

EEG.etc.noiseDetection.errors = errorMessages;
