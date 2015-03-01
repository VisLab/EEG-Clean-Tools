%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

dataDir =  'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz';
summaryFolder = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz_Report';
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
        filesep 'prepPipelineReport.pdf'];
    actualReportLocation = [summaryFolder filesep sessionFolder ...
        filesep sessionReportName];
    summaryReportLocation = [summaryFolder filesep summaryReportName];
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
%     if isfield(EEG.etc.noiseDetection, 'lineNoise')
%       [EEG, trend] = removeTrend(EEG, EEG.etc.noiseDetection.lineNoise);
%     end
%     %standardLevel2RevReport;
    publishPrepPipelineReport(EEG, summaryFolder, summaryReportName, ...
                      sessionFolder, sessionReportName);
end