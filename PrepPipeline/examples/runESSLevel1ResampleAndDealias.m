%% Example using ESS for the BCIT to resample
% ess2Dir = 'D:\TestData\BCITV2\Data\STDL2\ARL_BCIT_CalibrationDriving_Dataset_level_2';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'D:\TestData\BCITV2\Data\STDL2_256Hz\ARL_BCIT_CalibrationDriving_Dataset_level_2';

ess1Dir = 'D:\temp\VEPESS';
ess1File = [ess1Dir filesep 'study_description.xml'];
level1File = 'level1Derived_description.xml';
outputDir = 'D:\temp\VEPESSDown';
mkdir(outputDir);

%% Check to make sure level 1 study validates
obj1 = level1Study('essFilePath', ess1File);
obj1.validate();

%% Get the files from the level1 study
fileNames = getFilename(obj1);
params.resampleOff = false;
params.resampleFrequency = 128;
params.lowPassFrequency = 0;

for k = 1:length(fileNames)
    EEG = pop_loadset(fileNames{k});
    [~, theName, ~] = fileparts(fileNames{k});
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.resampleAndDealias = resampling;
    save([outputDir filesep theName '_downSampled.set'], 'EEG', '-v7.3');
end

