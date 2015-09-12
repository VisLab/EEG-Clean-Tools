%% Example using ESS for the BCIT for ICA on linux
pop_editoptions('option_single', false, 'option_savetwofiles', false);
ess2Dir = '/home/research/BCIT_ESS_256Hz';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];

% level2File = 'studyLevelDerived_description.xml';
% levelDerivedDir = '/home/research/BCIT_ESS_256Hz/X4 Advanced Guard Duty';
% levelDerivedDirNew = '/home/research/BCIT_ESS_256Hz_ICA\X4 Advanced Guard Duty';

level2File = 'studyLevelDerived_description.xml';
levelDerivedDir = '/home/research/BCIT_ESS_256Hz/X3 Baseline Guard Duty';
levelDerivedDirNew = '/home/research/BCIT_ESS_256Hz_ICA\X3 Baseline Guard Duty';

%% Make sure level 2 derived study validates
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);
obj.validate();

%% Call the HP and ICA combination
callbackAndParameters = {@highPassAndICALinux, {'detrendCutoff', 0.5}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
     'filterDescription', 'High pass filter at 0.5Hz followed by extended infomax', ...
     'filterLabel', 'hpICA', 'levelDerivedFolder', levelDerivedDirNew);
