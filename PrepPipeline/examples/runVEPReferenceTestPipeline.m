%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'N:\\ARLAnalysis\\VEPKenLineNoise\\HP1HzLineNoise'; % Input data directory used for this demo
params = struct();
%% Parameters that must be preset
params.referenceType = 'robust';
params.keepFiltered = true;
basenameOut = [basename '_testing'];
%% Run the pipeline
for k = 3%1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    [EEG, EEG1, referenceOut] = performReference1(EEG, params);

%     fname = [outdir1 filesep thisName '.set'];
%     EEG = EEG1;
%     save(fname, 'EEG', '-mat', '-v7.3'); 
%     fname = [outdir2 filesep thisName '.set'];
%     EEG = EEG2;
%     save(fname, 'EEG', '-mat', '-v7.3'); 
end
