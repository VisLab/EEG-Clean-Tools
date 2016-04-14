%% Example using ESS for the BCIT to perform ASR cleaning
% ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment X2 Traffic Complexity';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% 
% level2File = 'studyLevelDerived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment X2 Traffic Complexity';
% levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_ICA\Experiment X2 Traffic Complexity';

level2File = 'studyLevelDerived_description.xml';
levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X1 Baseline RSVP';
levelDerivedDirNew = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X1 Baseline RSVP';

%% Make sure level 2 derived study validates
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);

%% Call the HP and ICA combination
callbackAndParameters = {@cleanASR3, {'burstCriterion', 20}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
      'filterDescription', 'Use ASR to clean the data', ...
     'filterLabel', 'ASR', 'levelDerivedFolder', levelDerivedDirNew);
