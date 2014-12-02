%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
datadir = 'N:\\ARLAnalysis\\VEPStandardLevel2F';
summaryFolder = 'N:\\ARLAnalysis\\VEPStandardLevel2ReportsF';

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

