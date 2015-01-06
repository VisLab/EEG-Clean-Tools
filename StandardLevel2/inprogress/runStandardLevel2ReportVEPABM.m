%% Read in the file and set the necessary parameters
datadir = 'N:\\ARLAnalysis\\VEPABMStandardLevel2A';
summaryFolder = 'N:\\ARLAnalysis\\VEPABMStandardLevel2ReportsA';
basename = 'A';

summaryReportName = [basename 'BMVEP_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k) 
    sessionReportName = [thisName '.pdf'];
    fname = [datadir filesep thisName '.set'];
    try
       load(fname, '-mat');
    catch mex
        continue;
    end
    publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);
end

