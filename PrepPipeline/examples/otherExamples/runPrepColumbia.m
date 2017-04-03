%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
inDir = 'D:\Research\BlinkDetection\BlinksColumbiaTest\original';
outDir = 'D:\Research\BlinkDetection\BlinksColumbiaTest\prepped';
reportDir = 'D:\Research\BlinkDetection\BlinksColumbiaTest\report';
inFile = 'FlightSim12_blinksonly_taskmarked.set';
[thePath, theName, theExt] = fileparts(inFile);
params = struct();
%% Parameters that must be preset
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:64;
params.detrendChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.meanEstimateType = 'median';
params.interpolationOrder = 'post-reference';
params.keepFiltered = false;

%% Run the pipeline
fname = [inDir filesep inFile];
EEG = pop_loadset(fname);
params.name = [theName ' prepped'];
EEG = prepPipeline(EEG, params);
fname = [outDir filesep inFile];
save(fname, 'EEG', '-mat', '-v7.3'); 

%% Now run report
summaryFolder = reportDir;
summaryReportName = [theName '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end

publishOn = true;
sessionReportName = [theName '.pdf'];
sessionPath = [reportDir filesep sessionReportName];
consoleFID = 1;
publishPrepReport(EEG, reportSummary, sessionPath, ...
                                consoleFID, publishOn)
