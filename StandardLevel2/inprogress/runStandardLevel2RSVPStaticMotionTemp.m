%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\StaticMotionRSVP\\bad'; % Input data directory used for this demo
outdir = '.';
baddir = 'E:\\CTAData\\StaticMotionRSVP\\bad1';
%% Get a list of the files in the driving data from level 1
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);
params = struct();
params.lineFrequencies = [60, 120, 180, 240];

%% Read in the data and high-pass filter it.
for k = 1:2 %length(in_names)
    if ~strcmpi(in_names{k}(end-2:end), 'set')
        continue
    end;
    basename = in_names{k}(1:(end-4));
    thisName = basename;
    fname = [indir filesep in_names{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    params.name = thisName;
    params.referenceChannels = 1:64;
    params.rereferencedChannels = 1:64;
    params.highPassChannels = 1:64;
    params.lineNoiseChannels = 1:64;
    try
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf('Computation times (seconds): %g high pass, %g line noise, %g reference \n', ...
             computationTimes.highPass, computationTimes.lineNoise, ...
             computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    catch ex
        fname = [baddir filesep thisName '.set'];
    end
    save(fname, 'EEG', '-mat', '-v7.3');
end