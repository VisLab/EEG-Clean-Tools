%% Initialize
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Set the input and output directories
dataDir = 'N:\\ARLAnalysis\\VEPTesting\\Processed';
summaryFolder = 'N:\\ARLAnalysis\\VEPTesting\\Reports';
basename = 'vep_testMastoidNoise';
%% Create summary reports relative to reports
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end

%% Get a list of the files to generate reports on
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

for k = 1:length(inNames)
    thisFile = inNames{k}(1:(end-4));
    sessionReportName = [thisFile '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);
end