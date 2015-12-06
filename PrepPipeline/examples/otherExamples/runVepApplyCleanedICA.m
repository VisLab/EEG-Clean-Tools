%% Run the apply ICA on the vep dataset.  
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
description = ['Extended infomax ICA is computed on the vep data set ' ...
             'after PREP pipeline, filtering at 0.5Hz and performing ' ...
             'the standard cleaning procedure with badChannels at 0.15 ' ...
             'and std at 3. The ica is then applied to data right after PREP'];
indir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz';
indir1 = 'O:\ARL_Data\VEP\VEP_Robust_0p5HzHP_Cleaned_ICA_Extended';
outdir = 'O:\ARL_Data\VEP\VEP_Robust_WithCleanICA';
params = struct();
outdirICA = [outdir filesep 'ICAs'];
if ~exist(outdirICA, 'dir')
    mkdir(outdirICA);
end
    
%% Run the pipeline
modifyEEG = true;
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    EEG = pop_loadset([indir filesep thisName '.set']);
    EEG1 = pop_loadset([indir1 filesep thisName '.set']);
    [EEG, ICAs] = extractICA(EEG, EEG1, description, modifyEEG);

    EEG.setname = [EEG.setname  'ICA ext infomax from cleaned data'];    
    outfname = [outdir filesep thisName '.set'];
    save(outfname, 'EEG', '-v7.3');
    save([outdirICA filesep thisName 'ICAs.mat'], 'ICAs', '-v7.3'), 
end
