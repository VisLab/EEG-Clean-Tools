%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

dataDir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz';
%summaryFolder  = 'N:\\ARLAnalysis\\VEP\\VEP_Robust_1Hz_Report';
summaryFolder  = 'O:\ARL_Data\VEP\VEP_TRY';
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
for k = 1:2%length(inNames)
    sessionReportName = [inNames{k}(1:(end-4)) '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    sessionFolder = 'O:\ARL_Data\VEP\VEP_TRY\TRy1';
    %summaryReportLocation = [summaryFolder filesep summaryReportName];
    %summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    consoleFID = 1;
    publishPrepReport(EEG, summaryFolder, summaryReportName, ...
                      sessionFolder, sessionReportName, consoleFID, publishOn);
end