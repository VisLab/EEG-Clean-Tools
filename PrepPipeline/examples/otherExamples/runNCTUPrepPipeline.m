%% Example using ESS
% ess1Path = 'J:\\CTAData\\NCTULaneKeepingTask';
% ess1File = 'J:\\CTAData\\NCTULaneKeepingTask\\study_description.xml';
% ess2Dir = 'K:\\CTAData\NCTU\\Level2New1';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\\ARLAnalysis\\NCTU\\Level2';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\ARLAnalysis\\NCTUPrep\\NCTURobustHP1Hz';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\ARLAnalysis\\NCTUPrep\\NCTUAverageHP1Hz';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\ARLAnalysis\\NCTUPrep\\NCTUMastoidHP1Hz';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\\ARLAnalysis\\NCTUPrepNew\\NCTU_LK_Level2_Unfiltered';

% ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
% ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
% ess2Dir = 'N:\\ARLAnalysis\NCTU\\NCTURobust_1Hz';

ess1Path = 'E:\\CTAData\\01. NCTU lane-keeping task';
ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
ess2Dir = 'N:\\ARLAnalysis\NCTU\\NCTURobust_1Hz_New';
%% Validate level 1
obj1 = level1Study(ess1File);
obj1.validate();
clear obj1;
%% Create a level 2 study
obj2 = level2Study('level1XmlFilePath', ess1File);
obj2.createLevel2Study(ess2Dir);
