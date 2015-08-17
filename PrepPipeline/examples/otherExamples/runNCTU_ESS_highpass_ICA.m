%% Example using ESS for the NCTU to high pass filter after prep
ess2Dir = 'O:\ARL_Data\NCTU\NCTU_Robust_1Hz';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
level2File = 'level2Derived_description.xml';
levelDerivedDir = 'O:\ARL_Data\NCTU\NCTU_Robust_0p5HzHP_ICA';

%% Create a level 2 derived study
obj = levelDerivedStudy('parentStudyXmlFilePath', ess2File);
callbackAndParameters = {@highPassAndICA, {'detrendCutoff', 0.5}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
     'filterLabel', 'hpICA', 'levelDerivedFolder', levelDerivedDir);
