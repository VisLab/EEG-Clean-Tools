%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
dataDir = 'D:\Research\PREP\DataTestMock\original';
outDir = 'D:\Research\PREP\DataTestMock\prepped';
dataset = [dataDir filesep '395_+90_Kay.set'];
params = struct();

%% Parameters that must be preset
params.referenceChannels = [1:32, 34:42, 43:64];
params.evaluationChannels = [1:32, 34:42, 43:64];
params.rereferencedChannels = 1:66;
params.detrendChannels = 1:66;
params.lineNoiseChannels = 1:66;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.meanEstimateType = 'median';
params.interpolationOrder = 'post-reference';
params.keepFiltered = false;
params.removeInterpolatedChannels = true;
[~, thisName, ~] = fileparts(dataset);
outName = [thisName 'Prep_Unfiltered1Hz'];

%% Run the pipeline
EEG = pop_loadset(dataset);
[~, thisName, ~] = fileparts(dataset);
params.name = thisName;
[EEG, computationTimes] = prepPipeline(EEG, params);
fprintf('Computation times (seconds):\n   %s\n', ...
    getStructureString(computationTimes));
fname = [dataDir filesep outName '.set'];
save(fname, 'EEG', '-mat', '-v7.3');

%% Run the report
summaryFolder = 'D:\Research\PREP\DataTestMock\reportsNew';
summaryReportName = [outName '_summary.html'];
sessionFolder = '.';
summaryFileName = [summaryFolder filesep summaryReportName];
if exist(summaryFileName, 'file') 
   delete(summaryFileName);
end

publishOn = true;
sessionReportName = [outName '.pdf'];
sessionFileName = [summaryFolder filesep sessionReportName];
consoleFID = 1;
publishPrepReport(EEG, summaryFileName, sessionFileName, consoleFID, publishOn);