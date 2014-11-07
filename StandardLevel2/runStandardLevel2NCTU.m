%% Example using ESS
% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\ARLAnalysis\NCTU2\Level2';

ess1Path = 'J:\\NCTULaneKeeping';
ess1File = 'J:\NCTULaneKeeping\\study_description.xml';
ess2Dir = 'K:\\CTAData\\NCTU\\Level2';

%% Validate level 1
% obj1 = level1Study(ess1File);
% obj1.validate();

%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
%%
% obj2 = level2Study('level2XmlFilePath', ...
%     'N:\ARLAnalysis\NCTU\Level2\studyLevel2_description.xml');
% obj2.createLevel2Study();