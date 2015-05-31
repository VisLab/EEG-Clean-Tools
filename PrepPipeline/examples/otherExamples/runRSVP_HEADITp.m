%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'rsvp_headit';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\RSVP_HEADIT'; % Input data directory used for this demo
params = struct();
%% Parameters that must be preset
params.lineFrequencies = [60, 120];
params.referenceChannels = 1:64;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;

outdir1 = 'N:\\ARLAnalysis\\VEPKenLineNoise\\HP1Hz';
outdir2 = 'N:\\ARLAnalysis\\VEPKenLineNoise\\HP1HzLineNoise';

params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.keepFiltered = true;
basenameOut = [basename '_noreference_HP_' num2str(params.detrendCutoff)];
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG1, EEG2, computationTimes] = lineNoisePipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outdir1 filesep thisName '.set'];
    EEG = EEG1;
    save(fname, 'EEG', '-mat', '-v7.3'); 
    fname = [outdir2 filesep thisName '.set'];
    EEG = EEG2;
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
