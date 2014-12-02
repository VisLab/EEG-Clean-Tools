%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\Michigan_ESS_container_folder';
outdir = 'N:\ARLAnalysis\Michigan\Level2';
basename = 'EEGSession1';
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Parameters that must be preset
params = struct();
params.name = 'MichiganSession1';
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 4:259;
params.rereferencedChannels = 1:259;
params.highPassChannels = 1:259;
params.lineNoiseChannels = 1:259;
%% Run the pipeline
fname = [indir filesep basename '.set'];
EEG = pop_loadset(fname);
load ([indir filesep 'chanlocs.mat']);
%%
EEG.chanlocs = chanlocs;
%%
standardLevel2PipelineNoFunction;

%%
% [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
    computationTimes.highPass, computationTimes.resampling, ...
    computationTimes.lineNoise, computationTimes.reference);
fname = [outdir filesep basename '.set'];
%%
EEG.chaninfo.nosedir = '+X';
EEG.etc.noisyParameters.reference.channelInformation.nosedir = '+X';
%%
save(fname, 'EEG', '-mat', '-v7.3');


%%
datadir = 'N:\\ARLAnalysis\\Michigan\\Level2';
summaryFolder = 'N:\\ARLAnalysis\\Michigan\Level2Report';

summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end
sessionReportName = [basename '.pdf'];
publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                    sessionFolder, sessionReportName);
