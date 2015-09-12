%% Example using ESS for the BCIT to resample
% ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment X2 Traffic Complexity';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% 
% level2File = 'studyLevelDerived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment X2 Traffic Complexity';
% levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_ICA\Experiment X2 Traffic Complexity';

ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment XC Calibration Driving';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];

level2File = 'studyLevelDerived_description.xml';
levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment XC Calibration Driving';
levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_ICA\Experiment XC Calibration Driving';


%% Check to make sure level 2 study validates
% obj1 = level2Study('level2XmlFilePath', ess2File);
% obj1.validate();

%% Make sure level 2 derived study validates
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);
%obj.validate();

%% Call the HP and ICA combination
callbackAndParameters = {@highPassAndICA, {'detrendCutoff', 0.5}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
      'filterDescription', 'High pass filter at 0.5Hz followed by extended infomax', ...
     'filterLabel', 'hpICA', 'levelDerivedFolder', levelDerivedDirNew);
