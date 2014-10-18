%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\RSVP_HEADIT'; % Input data directory used for this demo
outdir = 'N:\\ARLAnalysis\\RSVPStandardLevel2B';  % Processed data directory
basename = 'rsvp';
fPassBand = [16, 128];

%% Parameters that must be preset
lineFrequencies = [16, 28, 30, 32, 44, 48, 60, 76, 92, 120];
referenceChannels = 1:248;
rereferencedChannels = 1:256;
highPassChannels = 1:256;
params = struct();
params.lineFrequencies = [16, 28, 30, 32, 44, 48, 60, 76, 92, 120];
params.referenceChannels = 1:248;
params.rereferencedChannels = 1:256;
params.highPassChannels = 1:256;
params.lineNoiseChannels = 1:256;
params.fPassBand = [16, 256];
%% Run the pipeline
for k = 14:15%[1:7, 9:15]
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    computationTimes= struct('highPass', 0, 'resampling', 0, 'lineNoise', 0, 'reference', 0);
    standardLevel2Pipeline;
    fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
             computationTimes.highPass, computationTimes.resampling, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end

