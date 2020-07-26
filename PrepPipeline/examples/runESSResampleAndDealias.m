%% Example using ESS for the BCIT to resample
ess2Dir = 'D:\TestData\LargData\NCTU\NCTU_DAS\Level2';
levelDerivedDir = 'D:\TestData\LargData\NCTU\NCTU_DAS\Level2_256Hz';

% ess2Dir = 'D:\TestData\BCITV2\Data\STDL2\ARL_BCIT_CalibrationDriving_Dataset_level_2';
% levelDerivedDir = 'D:\TestData\BCITV2\Data\STDL2_256Hz\ARL_BCIT_CalibrationDriving_Dataset_level_2';

% ess2Dir = 'D:\TestData\BCITV2\Data\STDL2\ARL_BCIT_TrafficComplexity_Dataset_level_2';
% levelDerivedDir = 'D:\TestData\BCITV2\Data\STDL2_256Hz\ARL_BCIT_TrafficComplexity_Dataset_level_2';

% ess2Dir = 'D:\TestData\LargData\VEP\ARL_VEP_v1.1.0_Level2';
% levelDerivedDir = 'D:\TestData\LargData\VEP\ARL_VEP_v1.1.0_Level2_256Hz';

% ess2Dir = 'D:\TestData\LargData\UCSD_RSVP\Level_2';
% levelDerivedDir = 'D:\TestData\LargData\UCSD_RSVP\Level_2_256Hz';

%% Check to make sure level 2 study validates
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
obj1 = level2Study('level2XmlFilePath', ess2File);
obj1.validate();

%% Create a level 2 derived study
obj = levelDerivedStudy('parentStudyXmlFilePath', ess2File);
callbackAndParameters = {@resampleAndDealias, {'resampleOff', false, ...
                        'resampleFrequency', 256, 'lowPassFrequency', 100}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
     'filterDescription', 'Downsample and then low pass to remove alias', ...
     'filterLabel', 'resample', 'levelDerivedFolder', levelDerivedDir); 
 
