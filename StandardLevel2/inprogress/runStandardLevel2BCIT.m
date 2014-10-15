%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\BCIT-3.0';  % Input data directory used for this demo
%outdir = 'E:\\CTAData\\BCIT-3.0HighPass';
%% Get a list of the files in the driving data from level 1
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);
lineFrequencies = [60, 120, 180, 240, 300, 360, 420];

%% Read in the data and high-pass filter it.
filterTimes = zeros(length(in_names), 1);
for k = 3%1:length(in_names)
    basename = in_names{k}(1:(end-4));
    thisName = basename;
    fname = [indir filesep in_names{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    chanblk = 32* floor(size(EEG.data, 1)/32);
    referenceChannels = 1:chanblk;
    rereferencedChannels = 1:(chanblk+6);
    highPassChannels = rereferencedChannels;
    rereferenceChannels = 1:(chanblk+6);
    standardLevel2Pipeline;
    fprintf('Computation times (seconds): %g high pass, %g line noise, %g reference \n', ...
             computationTimes.highPass, computationTimes.lineNoise, ...
             computationTimes.reference);
%     fname = [outdir filesep thisName '.set'];
%     save(fname, 'EEG', '-mat', '-v7.3');
end