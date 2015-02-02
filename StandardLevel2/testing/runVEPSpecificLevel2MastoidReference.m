%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
params = struct();
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrended';
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Parameters that must be preset

params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:68;
params.highPassChannels = 1:68;
params.lineNoiseChannels = 1:68;
params.specificReferenceChannels = 69:70;
params.detrendType = 'linear';
params.detrendCutoff = 1;
basenameOut = [basename 'mastoid_ref_cutoff' num2str(params.detrendCutoff)];
%% Run the pipeline (referencing to the mastoids before)
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG, computationTimes] = specificLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g detrend, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.detrend, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
