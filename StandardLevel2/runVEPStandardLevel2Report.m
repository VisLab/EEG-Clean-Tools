%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specific directory
% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2Average';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBefore';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2Mastoid';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeAverage';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeAverageReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustReports';

% datadir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2Robust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustReports';

dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrended';
summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports';

% dataDir =  'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrend';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrendReports';
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