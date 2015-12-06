%% Example using ESS for the BCIT to resample
% ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment X2 Traffic Complexity';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment X2 Traffic Complexity';

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X3 Baseline Guard Duty';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X3 Baseline Guard Duty';

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment X6 Speed Control';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment X6 Speed Control';

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\Experiment XB Baseline Driving';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\Experiment XB Baseline Driving';

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X4 Advanced Guard Duty';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X4 Advanced Guard Duty';

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
% ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
% level2File = 'level2Derived_description.xml';
% levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X2 RSVP Expertise';

ess2Dir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
levelDerivedDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X1 Baseline RSVP second runA';
%% Check to make sure level 2 study validates
obj1 = level2Study('level2XmlFilePath', ess2File);
obj1.validate();

%% Create a level 2 derived study
obj = levelDerivedStudy('parentStudyXmlFilePath', ess2File);
callbackAndParameters = {@resampleAndDealias, {'resampleOff', false, ...
                        'resampleFrequency', 256, 'lowPassFrequency', 100}};    
obj = obj.createLevelDerivedStudy(callbackAndParameters, ...
     'filterDescription', 'Downsample and then low pass to remove alias', ...
     'filterLabel', 'resample', 'levelDerivedFolder', levelDerivedDir); 
 
