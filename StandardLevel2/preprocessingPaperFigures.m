%%
summaryFolder = 'D:\\Papers\\Current\\Preprocessing\\Reports67';
sessionFolder = 'D:\\Papers\\Current\\Preprocessing\\Reports67';
summaryReportName = 'summaryTemp.html';
sessionReportName = 'NCTU67.pdf';
relativeReportLocation = [sessionFolder filesep sessionReportName];
summaryReportLocation = [summaryFolder filesep summaryReportName];
summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
consoleFID = 1;
fileName = 'N:\\ARLAnalysis\\NCTU\\Level2B\\session\\67\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_67_subject_1_task_motionless_s54_081209n_recording_1.set';
load(fileName, '-mat');
standardLevel2Report;