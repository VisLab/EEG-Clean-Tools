%% Example: Using Prep to high pass and reference to mastoids collection of data.
% You can also use a script such as this to high pass a "Prep'ed"
% collection before downstream processing.
%
%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
%% Parameters to preset
params = struct();
params.referenceChannels = 69:70;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
basenameOut = 'vep_mastoid_1Hz';
outdir = 'N:\\ARLAnalysis\\VEP\\VEPMastoid_1Hz';
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    EEG.data = double(EEG.data);
    refSignal = nanmean(EEG.data(params.referenceChannels, :), 1);
    EEG = removeReference(EEG, refSignal, params.rereferencedChannels);    
    EEG = removeTrend(EEG, params);
    params.mastoidReference = refSignal;
    params.noisyOut = findNoisyChannels(EEG, params);
    EEG.etc.mastoidReference = params;
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
