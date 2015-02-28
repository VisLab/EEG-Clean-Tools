%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\NCTURevisedData'; % Input data directory used for this demo
params = struct();
params.detrendType = 'high pass';
params.detrendCutoff = 1;

%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:30;
params.rereferencedChannels = 1:30;
params.detrendChannels = 1:30;
params.lineNoiseChannels = 1:30;

%% Run the pipeline
thisName = 's71_120312m';
fname = [indir filesep thisName 'WithChannels.set'];
EEG = pop_loadset(fname);
params.name = thisName;
[EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
fprintf(['Computation times (seconds): %g resampling,' ...
    '%g detrend, %g line noise, %g reference \n'], ...
    computationTimes.resampling, computationTimes.detrend, ...
    computationTimes.lineNoise, computationTimes.reference);
fname = [indir filesep thisName '_HP1.set'];
save(fname, 'EEG', '-mat', '-v7.3');

