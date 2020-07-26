%% Example using ESS
ess1Dir = 'D:\TestData\LargData\UCSD_RSVP\Level_1';
ess2Dir = 'D:\TestData\LargData\UCSD_RSVP\Level_2';
%% Validate level 1
ess1File = [ess1Dir filesep 'study_description.xml'];
obj1 = level1Study(ess1File);
obj1.validate();

clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
