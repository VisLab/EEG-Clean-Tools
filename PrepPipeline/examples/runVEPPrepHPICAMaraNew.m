%% Example: Running the PREP, HP, ICA, and MARA 

%% Read in the file and set the necessary parameters
basename = 'vep';
indir = 'E:\CTADATA\VEP\BiosemiOriginalSetCorrected';
finaldir = 'E:\CTADATA\VEPProcessedTest\Full';
params = struct();
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
params.keepFiltered = false;
baseSuffix = '_robust_1Hz_ICA_Mara';

%% Get the filelist
fileList = getFileList('FILES', indir);
%% Run the pipeline
for k = 1:length(fileList)
    [~, thisName, ~] = fileparts(fileList{k});
    EEG = pop_loadset(fileList{k});
    params.name = [thisName baseSuffix];
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    EEG = highPassAndICA(EEG, 'detrendCutoff', 1.0, ...
                        'icatype', 'runica', 'extended', 0);
    EEGin = EEG;
    icaChans = EEGin.icachansind;
    EEGin.chanlocs = EEG.chanlocs(icaChans);
    EEGin.nbchan = length(icaChans);
    EEGin.data = EEG.data(icaChans, :);
    [~, EEG, ~] = processMARA(EEGin, EEGin, 1, [0, 0, 0, 0, 1]); 
    fname = [finaldir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
