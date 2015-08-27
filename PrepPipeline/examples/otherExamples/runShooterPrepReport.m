%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);
basename = 'shooter';
dataDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered';
summaryFolder = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered_Report';
%% Get the directory list
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);
%% Set up the summary directories
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
    tempReportLocation = [summaryFolder filesep sessionFolder ...
        filesep 'prepPipelineReport.pdf'];
    actualReportLocation = [summaryFolder filesep sessionFolder ...
        filesep sessionReportName];
    summaryReportLocation = [summaryFolder filesep summaryReportName];
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepReport(EEG, summaryReportLocation, ...
        relativeReportLocation, 1,  true);
end