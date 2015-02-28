%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
outdir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoid';
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Parameters that must be preset
params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:68;
params.highPassChannels = 1:68;
params.lineNoiseChannels = 1:68;
params.specificReferenceChannels = 1:64;
%% Run the pipeline (referencing to the mastoids before)
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    params.name = thisName;
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    data1 = double(EEG.data);
    mastoidReference = mean(data1(69:70, :));
    data1 = data1 - repmat(mastoidReference, 70, 1);
    EEG.data = data1;
    [EEG, computationTimes] = specificLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g high pass, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.highPass, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
