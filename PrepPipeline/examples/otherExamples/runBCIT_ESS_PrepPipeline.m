%% Example using ESS
% ess1Path = 'E:\BCIT_ESS\Experiment XB Baseline Driving';
% ess1File = 'E:\BCIT_ESS\Experiment XB Baseline Driving\\study_description.xml';
% %ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_1_20';
% %ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_21_40';
% %ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_41_60';
% %ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_61_80';
% ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_78_90';

% ess1Path = 'E:\CTADATA\BCIT\level_1\Experiment X2 Traffic Complexity';
% ess1File = 'E:\CTADATA\BCIT\level_1\Experiment X2 Traffic Complexity\\study_description.xml';
% ess2Dir = 'O:\ARL_Data\BCIT_ESS_NEW\Experiment X2 Traffic Complexity';

ess1Path = 'E:\CTADATA\RSVP_UCSD\level_1';
ess1File = 'E:\CTADATA\RSVP_UCSD\level_1\\study_description.xml';
ess2Dir = 'O:\ARL_Data\BCIT_ESS_NEW\RSVP_UCSD';

% ess1Path = 'E:\BCIT_ESS\Experiment X6 Speed Control';
% ess1File = 'E:\BCIT_ESS\Experiment X6 Speed Control\\study_description.xml';
% ess2Dir = 'N:\BCIT_ESS_NEW\Experiment X6 Speed Control';
% 
% 
% ess1Path = 'E:\BCIT_ESS\X1 Baseline RSVP';
% ess1File = 'E:\BCIT_ESS\X1 Baseline RSVP\\study_description.xml';
% ess2Dir = 'N:\BCIT_ESS\X1 Baseline RSVP';

% ess1Path = 'E:\BCIT_ESS\level_1\X1 Baseline RSVP second run';
% ess1File = 'E:\BCIT_ESS\level_1\X1 Baseline RSVP second run\study_description.xml';
% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';

% ess1Path = 'E:\BCIT_ESS\X3 Baseline Guard Duty';
% ess1File = 'E:\BCIT_ESS\X3 Baseline Guard Duty\\study_description.xml';
% ess2Dir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';

% obj2 = level2Study('level2XmlFilePath', ess2Dir);
% obj2 = obj2.validate();

%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;

%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
