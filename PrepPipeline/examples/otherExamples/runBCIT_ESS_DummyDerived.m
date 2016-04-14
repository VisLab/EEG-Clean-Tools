%% Creates a dummy derived structure to do the re-editing
%experiment = 'Experiment X2 Traffic Complexity';
experiment = 'Experiment X6 Speed Control';
level2File = 'studyLevelDerived_description.xml';
baseDir = 'O:\ARL_Data\BCIT_ESS_256Hz';
cleanedICADir = 'O:\ARL_Data\BCIT_ESS_256Hz_0p5Hz_Cleaned_ICA_Extended';
outBaseDir = 'O:\ARL_Data\BCIT_ESS_256Hz_0p5Hz_With_Clean_ICA_Extended';

%% Create the study
levelDerivedDir = [baseDir filesep experiment];
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);
levelDerivedDirNew = [outBaseDir filesep experiment];
%% Call ESS to create a dummy structure.
callbackAndParameters = {@copyDummy, {}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
      'filterDescription', 'Copy cleaned ICA into EEG', ...
     'filterLabel', 'cpICA', 'levelDerivedFolder', levelDerivedDirNew);


