%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specific directory
% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2Average';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReports';

% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBefore';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeReports';

% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2Mastoid';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidReports';

% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverage';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverageReports';

% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobustReports';

% datadir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2Robust';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2RobustReports';

% datadir = 'N:\\ARLAnalysis\\VEPDetrend\\processedHP';
% summaryFolder = 'N:\\ARLAnalysis\\VEPDetrend\\reportsHP';

% dataDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrended';
% summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports';

dataDir =  'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrend';
summaryFolder = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustNoDetrendReports';
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