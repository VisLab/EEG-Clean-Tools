%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

dataDir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_New';
summaryFolder  = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_New_Report';

%% Get the directory list
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%%
basename = 'vep';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
summary = [summaryFolder filesep summaryReportName];
if exist(summary, 'file') 
   delete(summary);
end

%% Run the pipeline
publishOn = true;
for k = 1%2%length(inNames)
    sessionReportName = [inNames{k}(1:(end-4)) '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    session = [summaryFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepReport(EEG, summary, session, consoleFID, publishOn);
end