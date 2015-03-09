%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
params = struct();
%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;
%% Specific setup
% outdir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz';
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'robust';
% params.keepFiltered = true;
% basenameOut = [basename '_robustHP_cutoff' num2str(params.detrendCutoff)];

% outdir = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz';
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'specific';
% params.keepFiltered = true;
% params.referenceChannels = 69:70;
% basenameOut = [basename '_mastoidHP_cutoff' num2str(params.detrendCutoff)];

outdir = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz';
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'average';
params.keepFiltered = true;
basenameOut = [basename 'averageHP_cutoff' num2str(params.detrendCutoff)];
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
