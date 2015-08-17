%% Example: Running a postprocessing step (high pass + ICA) on a directory
%
% The filter that is run (highPassAndICA) illustrates how to handle
% reporting of the details of the filter in the .etc field.

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'O:\\ARL_Data\\VEP\\VEP_Robust_1Hz';
outdir = 'O:\\ARL_Data\\VEP\\VEP_Robust_0p5HzHP_ICA';
params = struct();
cutoff = 0.5;

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    EEG = highPassAndICA(EEG, 'detrendCutoff', cutoff);
    EEG.setname = [thisName  'Robust ' num2str(cutoff) ...
                   'Hz filtered ICA infomax'];    
    outfname = [outdir filesep thisName '.set'];
    save(outfname, 'EEG', '-v7.3');
end
