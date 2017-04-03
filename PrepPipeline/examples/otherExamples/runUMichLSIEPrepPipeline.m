%% Example: Running the pipeline outside of ESS

% %% Read in the file and set the necessary parameters
% basename = 'umich_lsie';
% params = struct();
% %% Parameters that must be preset
% params.referenceChannels = 1:256;
% params.evaluationChannels = 1:256;
% params.rereferencedChannels = 1:256;
% params.detrendChannels = 1:256;
% params.lineNoiseChannels = 1:256;
% 
% params.detrendType = 'high pass';
% params.detrendCutoff = 1;
% params.referenceType = 'robust';
% params.meanEstimateType = 'median';
% params.interpolationOrder = 'post-reference';
% params.keepFiltered = false;
% basenameOut = [basename 'robust_1Hz_post_median_unfiltered'];
% EEG = prepPipeline(EEG, params);

%% run report
summaryReportName = [basename '_summary.html'];
sessionFolder = 'D:\PREPWorkingCopy4\umich';
summaryFolder = sessionFolder;
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end

%%
%save([sessionFolder filesep basename '.set'], 'EEG', '-v7.3');

%% Run the pipeline
publishOn = false;
sessionReportName = [basename '.pdf'];
session = [sessionFolder filesep sessionReportName];
summary = [summaryFolder filesep summaryReportName];
consoleFID = 1;
publishPrepReport(EEG, summary, session, consoleFID, publishOn);
