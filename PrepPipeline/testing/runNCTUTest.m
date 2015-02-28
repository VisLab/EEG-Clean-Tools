%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

params = struct();
params.detrendType = 'high pass';
params.detrendCutoff = 1;

%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = [1:22, 24:28, 30:32];
params.evaluationChannels = [1:22, 24:28, 30:32];
params.rereferencedChannels = 1:32;
params.detrendChannels = 1:32;
params.lineNoiseChannels = 1:32;

%% Run the pipeline
EEG = pop_loadset('EEGNCTU4.set');
params.name = 's01_060606m';
[EEG, computationTimes] = standardLevel2RevPipeline(EEG, params);
fprintf('Computation times (seconds): %s\n', ...
    getStructureString(computationTimes));

% %% Run the report
% summaryReportLocation = 'NCTUSummary.html';
% relativeReportLocation= '.';
% summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
% consoleFID = 1;
% standardLevel2RevReport;