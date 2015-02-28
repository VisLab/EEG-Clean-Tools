%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specific directory
% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrendedReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrendedReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrendedReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeAverage';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeAverageReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2Robust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrendedReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5Reports';

% dataDir =  'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrend';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrendReports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p5';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p5Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored\\VEPStandardLevel2RobustHPCutoff1';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored\\VEPStandardLevel2RobustHPCutoff1_Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPCutoff1';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPCutoff1_Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2AverageHPCutoff1';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2AverageHPCutoff1_Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2MastoidHPCutoff1';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPSpecificLevel2MastoidHPCutoff1_Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPSincCutoff02';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RobustHPSincCutoff02_Reports';

% dataDir = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RevRobustHPCutoff0p3';
% summaryFolder = 'N:\\ARLAnalysis\\VEPTrendRefactored2\\VEPStandardLevel2RevRobustHPCutoff0p3_Reports';

dataDir =  'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2Test';
summaryFolder = 'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2Test_reports';
%% Get the directory list
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
%%
basename = 'vep';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end
%% Run the pipeline
for k = 1:length(inNames)
    sessionReportName = [inNames{k}(1:(end-4)) '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);
end