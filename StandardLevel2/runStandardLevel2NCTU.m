%% Example using ESS
ess1File = 'E:\\CTAData\\01. NCTU lane-keeping task\\study_description.xml';
ess2Dir = 'N:\ARLAnalysis\NCTU\Level2';
obj = level2Study('level1XmlFilePath', ess1File);

% create level 2 folder
obj.createLevel2Study(ess2Dir);
