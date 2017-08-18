%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

% dataDir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz';
% summaryFolder  = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_New_Report_B';

dataDir = 'D:\TempCTA';
summaryFolder = 'D:\TempCTA';
publishOn = true;
%% Get the directory list
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%%
basename = 'vep';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
summaryFileName = [summaryFolder filesep summaryReportName];
if exist(summaryFileName, 'file') 
   delete(summaryFileName);
end

%% Run the pipeline

for k = 1:length(inNames)
    sessionReportName = [inNames{k}(1:(end-4)) '.pdf'];
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    sessionFileName = [summaryFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepReport(EEG, summaryFileName, sessionFileName, consoleFID, publishOn);
end