params = struct();
params.detrendType = 'high pass';
params.detrendCutoff = 1.0;

EEG.data = double(EEG.data);
basename = EEG.filename;
thisName = basename(1:(end-4));
chanblk = 32* floor(size(EEG.data, 1)/32);
params.name = thisName;
params.referenceChannels = 1:chanblk;
params.evaluationChannels = 1:chanblk;
params.rereferencedChannels = 1:(chanblk+6);
params.detrendChannels = 1:(chanblk+6);
params.lineNoiseChannels = 1:(chanblk+6);
[EEG, computationTimes] = prepPipeline(EEG, params);

%%
summaryFolder = 'D:\Temp';
sessionFolder = 'D:\Temp';
summaryReportName = 'temp.html';
sessionReportName = 'temp1.html';
publishOn = false;
publishPrepPipelineReport(EEG, summaryFolder, summaryReportName, ...
                 sessionFolder, sessionReportName, publishOn)