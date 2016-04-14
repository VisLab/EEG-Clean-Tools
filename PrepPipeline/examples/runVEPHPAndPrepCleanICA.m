%% Run highPassAndPrepCleanICA on VEP PREPPED data

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz'; % Input data directory used for this demo
outdir = 'O:\ARL_Data\VEP\VEP_PrepClean_Infomax';

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    EEG = highPassAndPrepCleanICA(EEG, 'detrendCutoff', 1.0, ...
        'icatype', 'runica', 'extended', 0, 'fractionBad', 0.1);
    EEG.setname = [EEG.setname  'HP and PREP Clean then ICA Infomax'];   
    fname = [outdir filesep thisName '.set'];
    pop_saveset(EEG, 'filename', [thisName '.set'], 'filepath', outdir, ...
                'version', '7.3'); 
end
