%% Example using ESS for the NCTU high pass and prep clean ICA for blinks
% level2File = 'studyLevel2_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS\Experiment X2 Traffic Complexity';
% levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_PrepClean_ICA\Experiment X2 Traffic Complexity';

level2File = 'studyLevel2_description.xml';
levelDerivedDir = 'O:\ARL_Data\BCIT_ESS\Experiment X6 Speed Control';
levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_PrepClean_ICA\Experiment X6 Speed Control';

%% Make sure level 2 derived study validates
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);

%% Call the HP and ICA combination
callbackAndParameters = {@resampleHighPassAndPrepCleanICA, ...
    {'resampleOff', false, 'resampleFrequency', 256, ...
    'lowPassFrequency', 100, 'detrendCutoff', 1.0, 'icatype', ...
    'runica', 'extended', 0, 'fractionBad', 0.1}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
      'filterDescription', 'Resample HP and PREP Clean then ICA Infomax', ...
     'filterLabel', 'ResampHPPrepICA', ...
     'levelDerivedFolder', levelDerivedDirNew);