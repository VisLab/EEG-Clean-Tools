%% Example: Using Prep to high pass filter a collection of data.
% You can also use a script such as this to high pass a "Prep'ed"
% collection before downstream processing.
%
%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
outdir = 'N:\\ARLAnalysis\\VEP\\VEP_1Hz';
%% Parameters to preset
params = struct();
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'none';
basenameOut = 'vep_1Hz';

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    EEG.data = double(EEG.data);
    EEG = removeTrend(EEG, params);
    params.originalReference = [];
    params.noisyOut = findNoisyChannels(EEG, params);
    EEG.etc.originalReference = params;
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
