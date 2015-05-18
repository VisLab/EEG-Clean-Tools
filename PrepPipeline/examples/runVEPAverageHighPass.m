%% Example: Calculate the average reference and highpass filter dataset
%
% Script assumes files in a single directory and writes to a new directory
%
%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
%% Parameters to preset
params = struct();
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
basenameOut = 'vep_average_1Hz';
outdir = 'N:\\ARLAnalysis\\VEP\\VEPAverage_1Hz';

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
    params.averageReference = refSignal;
    params.noisyOut = findNoisyChannels(EEG, params);
    EEG.etc.averageReference = params;
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
