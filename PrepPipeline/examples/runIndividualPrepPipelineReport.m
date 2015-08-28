%% Run a PREP report on an individual dataset -- good for producing figures.
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specific examples
% dataFile = 'N:\ARLAnalysis\VEP\VEPRobust_1Hz_Post_Median_Unfiltered\vep_03.set';
% summaryFolder = 'D:\\Temp';
% basename = 'vep';
% publishOn = false;

% dataFile = 'N:\ARLAnalysis\VEP\VEPRobust_1Hz_Post_Median_Unfiltered\vep_15.set';
% summaryFolder = 'D:\\Temp';
% basename = 'vep';
% publishOn = false;

% dataFile = 'N:\ARLAnalysis\VEP\VEPRobust_1Hz_Post_Median_Unfiltered\vep_02.set';
% summaryFolder = 'D:\\Temp';
% basename = 'vep';
% publishOn = false;

% dataFile = 'N:\\ARLAnalysis\\NCTU\NCTURobust_1Hz_New\\session\\67\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_67_subject_1_task_motionless_s54_081209n_recording_1.set';
% summaryFolder = 'D:\\Temp';
% basename = 'nctu-lk';
% publishOn = false;

% dataFile = 'N:\ARLAnalysis\NCTU\NCTURobust_1Hz_New\session\79\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_79_subject_1_task_motion_s77_120504m_recording_1.set';
% summaryFolder = 'D:\\Temp';
% basename = 'nctu-lk';
% publishOn = false;

% dataFile = 'N:\\ARLAnalysis\\NCTU\\NCTURobust_1Hz_New\\session\\80\\eeg_studyLevel2_NCTU_Lane-Keeping_Task_session_80_subject_1_task_motion_s80_120522m_recording_1.set';
% summaryFolder = 'D:\\Temp';
% basename = 'nctu-lk';
% publishOn = false;

% dataFile = 'N:\ARLAnalysis\Shooter\Shooter_Robust_1Hz_Unfiltered\\ARIT_0131_CNT_events.set';
% summaryFolder = 'D:\\Temp';
% basename = 'shooter-1';
% publishOn = false;

dataFile = 'N:\\ARLAnalysis\\RSVP_HeadIT\\RSVP_Robust_1Hz\\rsvp_01.set';
summaryFolder = 'D:\\Temp';
basename = 'rsvp-1';
publishOn = true;

%% Setup up the summary folder
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end

%% Run the pipeline
[pathstr, fname, ext] = fileparts(dataFile);
sessionReportName = [fname '.pdf'];
load(dataFile, '-mat');
tempReportLocation = [summaryFolder filesep sessionFolder ...
    filesep 'prepPipelineReport.pdf'];
actualReportLocation = [summaryFolder filesep sessionFolder ...
    filesep sessionReportName];
summaryReportLocation = [summaryFolder filesep summaryReportName];
summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
relativeReportLocation = [sessionFolder filesep sessionReportName];
consoleFID = 1;
publishPrepReport(EEG, reportSummary, actualReportLocation, 1, publishOn);

%% Calculate the mean correlations
meanBefore = EEG.etc.noiseDetection.reference.noisyStatisticsOriginal.maximumCorrelations;
meanBeforeInterp = EEG.etc.noiseDetection.reference.noisyStatisticsBeforeInterpolation.maximumCorrelations;
meanAfter = EEG.etc.noiseDetection.reference.noisyStatistics.maximumCorrelations;
fprintf('Mean before: %g\n', mean(meanBefore(:)));
fprintf('mean before Interpolation: %g\n', mean(meanBeforeInterp(:)));
fprintf('Mean after: %g\n', mean(meanAfter(:)));