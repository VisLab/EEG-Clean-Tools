%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

% dataDir =  'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered_Report';
% dataDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTest';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPTestReport';

% dataDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTestPost';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPTestPostReport';

% dataDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTest2';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPTest2Report';
% dataDir =  'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_Unfiltered';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_Unfiltered_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrepNew\\VEPTest';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPTest_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_1Hz_Unfiltered';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_1Hz_Unfiltered_Report';

% dataDir =  'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_0p3Hz_Unfiltered';
% summaryFolder = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_0p3Hz_Unfiltered_Report';

dataDir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered';
summaryFolder  = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered_Report';

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
publishOn = true;
for k = 1:length(inNames)
    sessionReportName = [inNames{k}(1:(end-4)) '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    tempReportLocation = [summaryFolder filesep sessionFolder ...
        filesep 'prepPipelineReport.pdf'];
    actualReportLocation = [summaryFolder filesep sessionFolder ...
        filesep sessionReportName];
    summaryReportLocation = [summaryFolder filesep summaryReportName];
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepPipelineReport(EEG, summaryFolder, summaryReportName, ...
                      sessionFolder, sessionReportName, publishOn);
end