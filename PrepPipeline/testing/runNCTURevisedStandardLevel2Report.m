%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specific directory
dataDir = 'E:\\NCTURevisedData'; % Input data directory used for this demo
summaryFolder = 'E:\\NCTURevisedData';
thisName = 's71_120312m_HP1';

%%
summaryReportName = [thisName '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep thisName];
if exist(reportSummary, 'file')
    delete(reportSummary);
end

sessionReportName = [thisName '.pdf'];
fname = [dataDir filesep thisName '.set'];
load(fname, '-mat');
publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
    sessionFolder, sessionReportName);