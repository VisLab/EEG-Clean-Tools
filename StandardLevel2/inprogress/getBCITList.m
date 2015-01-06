%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\CTAData\ARL_BCIT_Program\STDL1'; % Input data directory used for this demo
outdir = 'N:\\ARL_BCIT_Program\\Level2';
%% Get a list of the files in the driving data from level 1
inList = dir(indir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

markers = true(size(inNames));

for k = 1:length(inNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        markers(k) = false;
    end
end
actualNames = inNames(markers);
%% Out list
outList = dir(outdir);
outNames = {outList(:).name};
outTypes = [outList(:).isdir];
outNames = outNames(~outTypes);

%%
leftNames = setdiff(actualNames, outNames);

%% Read in the data and high-pass filter it.
params = struct();
params.lineFrequencies = [60, 120, 180, 240];
for k = 1:length(leftNames)
    ext = inNames{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    basename = inNames{k}(1:(end-4));
    thisName = basename;
    fname = [indir filesep inNames{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    chanblk = 32* floor(size(EEG.data, 1)/32);
    params.name = thisName;
    params.referenceChannels = 1:chanblk;
    params.rereferencedChannels = 1:(chanblk+6);
    params.highPassChannels = 1:(chanblk+6);
    params.lineNoiseChannels = 1:(chanblk+6);
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf('Computation times (seconds): %g high pass, %g line noise, %g reference \n', ...
             computationTimes.highPass, computationTimes.lineNoise, ...
             computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end