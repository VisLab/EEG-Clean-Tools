%% Example using ESS for the NCTU high pass and prep clean ICA for blinks
level2File = 'studyLevel2_description.xml';
levelDerivedDir = 'O:\ARL_Data\NCTU\NCTU_Robust_1Hz';
levelDerivedDirNew = 'O:\ARL_Data\NCTU\NCTU_PrepClean_InfomaxNewA';

%% Make sure level 2 derived study validates
derivedXMLFile = [levelDerivedDir filesep level2File];
obj = levelDerivedStudy('parentStudyXmlFilePath', derivedXMLFile);

%% Call the HP and ICA combination
callbackAndParameters = {@highPassAndPrepCleanICA, ...
    {'detrendCutoff', 1.0, 'icatype', 'runica', 'extended', 0, ...
                        'fractionBad', 0.1}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
      'filterDescription', 'HP and PREP Clean than ICA Infomax', ...
      'sessionSubset', 72:80, ...
     'filterLabel', 'HPPrepICA', 'levelDerivedFolder', levelDerivedDirNew);