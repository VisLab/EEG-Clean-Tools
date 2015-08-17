% Script to run resampleAndDealias
ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment X2 Traffic Complexity';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
level2File = 'level2Derived_description.xml';
levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment X2 Traffic Complexity';

%% Check to make sure level 2 study validates
obj1 = level2Study('level2XmlFilePath', ess2File);
obj1.validate();

%% Create a level 2 derived study
obj = levelDerivedStudy('parentStudyXmlFilePath', ess2File);
callbackAndParameters = {@resampleAndDealias, {'resampleOff', false, ...
                        'resampleFrequency', 256, 'lowPassFrequency', 100}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
     'filterLabel', 'resample', 'levelDerivedFolder', levelDerivedDir); 
 
