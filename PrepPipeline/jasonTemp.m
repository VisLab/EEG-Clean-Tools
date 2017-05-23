%% Example: Running the pipeline outside of ESS
%% Read in the file and set the necessary parameters
params = struct();
params.referenceChannels = 1:61;
params.evaluationChannels = 1:61;
params.rereferencedChannels = 1:64;
params.detrendChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.meanEstimateType = 'median';
params.interpolationOrder = 'post-reference';
params.keepFiltered = false;
EEG = pop_loadset('D:\TestData\PREP\Palmer\new\03_auda_lab.set');
EEG.event = EEG.event([2:285, 287:end]);
[EEG, computationTimes] = prepPipeline(EEG, params);

%%
summaryFileName = 'D:\TestData\PREP\Palmer\new\03_auda_lab.html';
sessionFileName = 'D:\TestData\PREP\Palmer\new\03_auda_lab.pdf';
publishPrepReport(EEG, summaryFileName, sessionFileName, 1, true);