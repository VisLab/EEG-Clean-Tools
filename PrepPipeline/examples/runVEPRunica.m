%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'O:\\ARL_Data\\VEP\\VEP_Robust_1Hz_Filtered';
outdir = 'O:\\ARL_Data\\VEP\\VEP_Robust_1Hz_Filtered_ICA';
params = struct();

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    referenceChannels = EEG.etc.noiseDetection.reference.referenceChannels;
    interpolatedChannels = EEG.etc.noiseDetection.reference.interpolatedChannels.all;
    channelsLeft = setdiff(referenceChannels, interpolatedChannels);
    pcaDim = length(channelsLeft) - 1;
    EEG = pop_runica(EEG, 'icatype', 'runica', ...
                    'chanind', referenceChannels, 'pca', pcaDim);
    EEG.setname = [thisName  'Robust 1Hz filtered ICA infomax'];    
    outfname = [outdir filesep thisName '.set'];
    save(outfname, 'EEG', '-v7.3');
end
