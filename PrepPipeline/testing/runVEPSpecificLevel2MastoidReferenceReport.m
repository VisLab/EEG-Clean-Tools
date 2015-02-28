%% Read in the file and set the necessary parameters
datadir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReference';
summaryFolder = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports';
basename = 'vep';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end
%% Run the pipeline
for k = 1:18
    thisFile = sprintf('%s_%02d', basename, k);
    sessionReportName = [thisFile '.pdf'];
    fname = [datadir filesep thisFile '.set'];
    load(fname, '-mat');
    
    publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);
end