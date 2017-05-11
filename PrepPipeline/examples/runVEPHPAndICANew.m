%% Example running ICA on prepped data (no ESS)

%% Read in the file and set the necessary parameters
prepdir = 'E:\CTADATA\VEPProcessedTest\Prep';
icadir = 'E:\CTADATA\VEPProcessedTest\Prep_ICA';

%% Get the filelist
fileList = getFileList('FILES', prepdir);
%% Run the pipeline
for k = 1:length(fileList)
    [~, thisName, ~] = fileparts(fileList{k});
    EEG = pop_loadset(fileList{k});
    EEG = highPassAndICA(EEG, 'detrendCutoff', 1.0, ...
                        'icatype', 'runica', 'extended', 0);
    fname = [icadir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
