%% Example using ESS
ess1Path = 'E:\\BCIT_ESS\\Experiment X2 Traffic Complexity';
ess1File = 'E:\\BCIT_ESS\\Experiment X2 Traffic Complexity\\study_description.xml';
ess2Dir = 'N:\\BCIT_ESS\\Experiment X2 Traffic Complexity';

%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
