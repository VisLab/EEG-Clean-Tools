%% Testing VEP data
%% Set the parameters for generating noisy data
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir = 'N:\\ARLAnalysis\\VEPTesting\\NoiseAdded';
outDir = 'N:\\ARLAnalysis\\VEPTesting\\Processed';

%% Get a list of the noisy data files
inList = dir(inDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%% Set the parameters for the processing
params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.highPassChannels = 1:70;
params.lineNoiseChannels = 1:70;

%% Generate the new datasets
for k = 1:length(inNames)
    %% Run the standard robust reference
    params.specificReferenceChannels = [];
    baseName = inNames{k}(1:(end - 4));
    fprintf('%s:\n', baseName);
    inFileName = [inDir filesep inNames{k}];
    EEGOrig = pop_loadset(inFileName);
    [EEG, computationTimes] = standardLevel2Pipeline(EEGOrig, params); %#ok<ASGLU>
    fprintf(['Computation times (seconds): %g resampling,' ...
        '%g high pass, %g line noise, %g reference \n'], ...
        computationTimes.resampling, computationTimes.highPass, ...
        computationTimes.lineNoise, computationTimes.reference);
    fname = [outDir filesep baseName  '_robust.set'];
    fprintf('%d: saving %s\n', k, fname);
    save(fname, 'EEG', '-mat', '-v7.3');
    %% Run a mastoid reference
    params.specificReferenceChannels = 69:70;
    [EEG, computationTimes] = specificLevel2Pipeline(EEGOrig, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
        '%g high pass, %g line noise, %g reference \n'], ...
        computationTimes.resampling, computationTimes.highPass, ...
        computationTimes.lineNoise, computationTimes.reference);
    fname = [outDir filesep baseName  '_mastoid.set'];
    fprintf('%d: saving %s\n', k, fname);
    save(fname, 'EEG', '-mat', '-v7.3');
end    