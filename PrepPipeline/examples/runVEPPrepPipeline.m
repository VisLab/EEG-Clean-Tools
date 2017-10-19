%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
indir = 'E:\CTADATA\VEP\BiosemiOriginalSetCorrected';
outdir = 'D:\TempCTA';
params = struct();

%% Make directory if needed
if ~exist(outdir, 'dir')
    mkdir(outdir)
end

%% Parameters that must be preset
params.lineFrequencies = [60, 120, 180, 212, 240];
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;

params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.meanEstimateType = 'median';
params.interpolationOrder = 'post-reference';
params.removeInterpolatedChannels = true;
params.keepFiltered = false;
basenameOut = [basename 'robust_1Hz_post_median_unfiltered'];

%% Get the filelist
fileList = getFileList('FILES', indir);
%% Run the pipeline
for k = 1%:length(fileList)
    [~, thisName, ~] = fileparts(fileList{k});
    EEG = pop_loadset(fileList{k});
    params.name = thisName;
    [EEG, params, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fprintf('Post-process\n')
    EEG = prepPostProcess(EEG, params);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
