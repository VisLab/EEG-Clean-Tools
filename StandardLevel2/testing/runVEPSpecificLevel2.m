%% Example: Running the pipeline with specific referencing
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\';  
basename = 'vep';
params = struct();
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:68;
params.detrendChannels = 1:68;
params.lineNoiseChannels = 1:68;

%% Specific parameter settings for different cases
%-----------------------------Mastoid reference---------------------------
params.specificReferenceChannels = 69:70;
params.detrendType = 'linear';
params.detrendCutoff = 1;
basenameOut = [basename 'mastoid_ref_cutoff' num2str(params.detrendCutoff)];
outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrended';

%-----------------------------Average reference---------------------------
% params.specificReferenceChannels = 1:64;
% params.detrendType = 'linear';
% params.detrendCutoff = 1;
% basenameOut = [basename 'average_ref_cutoff' num2str(params.detrendCutoff)];
% outdir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrended';

%% Run the pipeline (referencing to the mastoids before)
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG, computationTimes] = specificLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g high pass, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.detrend, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
