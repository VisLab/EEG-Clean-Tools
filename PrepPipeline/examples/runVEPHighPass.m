%% Example: Using Prep to high pass filter a collection of data.
% You can also use a script such as this to high pass a "Prep'ed"
% collection before downstream processing.
%
%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Parameters to preset
params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;
%% Specific setup
% Pre - huber - 0.3Hz
indir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_0p3Hz_Pre_Huber_Unfiltered';
outdir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_0p3Hz_Pre_Huber_Filtered';
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
params.referenceType = 'robust';
basenameOut = 'vep_robust_pre_huber_0p3Hz_filtered';

% %Post - median - 0.3Hz
% indir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_0p3Hz_Post_Median_Unfiltered';
% outdir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_0p3Hz_Post_Median_Filtered';
% params.detrendType = 'high pass';
% params.detrendCutoff = 0.3;
% params.referenceType = 'robust';
% basenameOut = 'vep_robust_post_median_0p3Hz_filtered';

% % Pre - huber - 1Hz
% indir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Pre_Huber_Unfiltered';
% outdir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Pre_Huber_Filtered';
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'robust';
% basenameOut = 'vep_robust_pre_huber_1Hz_filtered';

%Post - median - 1Hz
indir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered';
outdir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Filtered';
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
basenameOut = 'vep_robust_post_median_1Hz_filtered';
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    EEG.data = double(EEG.data);
    EEG = removeTrend(EEG, params);
    EEG.setname = thisNameOut;
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
