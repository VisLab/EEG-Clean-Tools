%% This script tries running the prep pipeline
ess1Dir = 'D:\TestData\LargData\UCSD_RSVP\Level_1';
ess1File = 'study_description.xml';
outDir = 'D:\TestData\LargData\UCSD_RSVP\PrepOut';

%% Make directory if needed
if ~exist(outDir, 'dir')
    mkdir(outDir)
end

%% Load the ESS container and fix the file names
ess1Path = [ess1Dir filesep ess1File];
obj1 = level1Study(ess1Path);
fileNames = obj1.getFilename();

%% Replace where needed
for k = 1%:length(fileNames)
    [~, thisName, ~] = fileparts(fileNames{k});
    params = struct();      
    %% Parameters that must be preset
    params.referenceChannels = 1:248;
    params.evaluationChannels = 1:248;
    params.rereferencedChannels = 1:248;
    params.detrendChannels = 1:256;
    params.lineNoiseChannels = 1:256;
    
    params.detrendType = 'high pass';
    params.detrendCutoff = 1;
    params.referenceType = 'robust';
    params.meanEstimateType = 'median';
    params.interpolationOrder = 'post-reference';
    params.removeInterpolatedChannels = false;
    params.keepFiltered = false;
    basenameOut = [thisName '_prep'];
   
    EEG = pop_loadset(fileNames{k});
    params.name = thisName;
    [EEG, params, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fprintf('Post-process\n')
    EEG = prepPostProcess(EEG, params);
    fname = [outDir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
