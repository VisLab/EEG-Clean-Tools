%% Example using ESS
ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
ess2Dir = 'O:\ARL_Data\NCTU\\NCTU_Temp';
%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
