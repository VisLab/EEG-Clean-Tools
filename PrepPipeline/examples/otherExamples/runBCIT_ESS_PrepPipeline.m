%% Example using ESS
ess1Path = 'E:\BCIT_ESS\Experiment XB Baseline Driving';
ess1File = 'E:\BCIT_ESS\Experiment XB Baseline Driving\\study_description.xml';
%ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_1_20';
%ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_21_40';
%ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_41_60';
%ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_61_80';
ess2Dir = 'N:\\BCIT_ESS\\Experiment XB Baseline Driving_78_90';
%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir, 'sessionSubset', 78:90);
