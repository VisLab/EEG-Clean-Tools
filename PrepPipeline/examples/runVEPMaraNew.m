%% Example running ICA on prepped data (no ESS)

%% Read in the file and set the necessary parameters
icadir = 'E:\CTADATA\VEPProcessedTest\Prep_ICA';
maradir = 'E:\CTADATA\VEPProcessedTest\Prep_ICA_Mara';
%% Get the filelist
fileList = getFileList('FILES', icadir);
%% Run the pipeline
for k = 1:length(fileList)
    [~, thisName, ~] = fileparts(fileList{k});
    EEG = pop_loadset(fileList{k});
    EEGin = EEG;
    icaChans = EEGin.icachansind;
    EEGin.chanlocs = EEG.chanlocs(icaChans);
    EEGin.nbchan = length(icaChans);
    EEGin.data = EEG.data(icaChans, :);
    [~, EEG, ~] = processMARA(EEGin, EEGin, 1, [0, 0, 0, 0, 1]);             
    fname = [maradir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
