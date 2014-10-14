%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
%outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2A';
basename = 'vep';

pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Parameters that must be preset
params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.highPassChannels = 1:70;

%% Run the pipeline
for k = 3%1:18
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

