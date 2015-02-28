%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

dataDir =  'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2GlobalLocalTrend';
summaryFolder = 'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2GlobalLocalTrend_Reports';
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
    tempReportLocation = [summaryFolder filesep sessionFolder ...
        filesep 'standardLevel2RevReport.pdf'];
    actualReportLocation = [summaryFolder filesep sessionFolder ...
        filesep sessionReportName];
    summaryReportLocation = [summaryFolder filesep summaryReportName];
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
    %standardLevel2RevReport;
    publishLevel2RevReport(EEG, summaryFolder, summaryReportName, ...
                      sessionFolder, sessionReportName);
end