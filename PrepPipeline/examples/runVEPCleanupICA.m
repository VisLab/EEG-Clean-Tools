%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_ICA_Extended'; % Input data directory used for this demo
indirCleaned = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_Cleaned_ICA_Extended';
outdir = 'O:\ARL_Data\VEP\VEP_Robust_1Hz_ICAClean_Extended';
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    fnameCleaned = [indirCleaned filesep thisName '.set'];
    EEGCleaned = pop_loadset(fnameCleaned);
    if size(EEG.icawinv, 1) ~= size(EEGCleaned.icawinv, 1) || ...
       size(EEG.icawinv, 1) ~= size(EEGCleaned.icawinv, 1)
       warning('%s: icawinv sizes don''t match', thisName);
       break;
    elseif size(EEG.icasphere, 1) ~= size(EEGCleaned.icasphere, 1) || ...
       size(EEG.icasphere, 1) ~= size(EEGCleaned.icasphere, 1)
       warning('%s: icasphere sizes don''t match', thisName);
       break;
    elseif size(EEG.icaweights, 1) ~= size(EEGCleaned.icaweights, 1) || ...
       size(EEG.icaweights, 1) ~= size(EEGCleaned.icaweights, 1)
       warning('%s: icaweights sizes don''t match', thisName);
       break;
    elseif length(intersect(EEG.icachansind, EEGCleaned.icachansind)) ~= ...
           length(EEG.icachansind)
       warning('%s: the ICA channels don''t match', thisName);
       break;
    end
    EEG.icasphere = EEGCleaned.icasphere;
    EEG.icaweights = EEGCleaned.icaweights;
    EEG.icawinv = EEGCleaned.icawinv;
    EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end
