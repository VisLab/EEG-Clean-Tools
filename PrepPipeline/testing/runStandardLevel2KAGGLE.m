%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir1 = 'E:\\CTAData\\KaggleBCI\\train'; % Input data directory used for this demo
inDir2 = 'E:\\CTAData\\KaggleBCI\\test'; % Input data directory used for this demo
% outDir1 = 'N:\\ARLAnalysis\\KaggleBCI\\train';
% outDir2 = 'N:\\ARLAnalysis\\KaggleBCI\\test';
outDir1 = 'N:\\ARLAnalysis\\KaggleBCIStandardLevel2Detrended\\train';
outDir2 = 'N:\\ARLAnalysis\\KaggleBCIStandardLevel2Detrended\\test';
%% Get a list of the files in the driving data from level 1
inList1 = dir(inDir1);
inNames1 = {inList1(:).name};
inTypes1 = [inList1(:).isdir];
inNames1 = inNames1(~inTypes1);
inList2 = dir(inDir2);
inNames2 = {inList2(:).name};
inTypes2 = [inList2(:).isdir];
inNames2 = inNames2(~inTypes2);
%% Parameters
params = struct();
params.lineFrequencies = [50, 60, 100, 120, 180, 240, 300];
params.lineNoiseChannels = 1:56;
params.highPassChannels = 1:56;
params.referenceChannels = 1:56;
params.rereferenceChannels = 1:56;
params.detrendChannels = 1:56;
params.detrendCutoff = 0.2;
params.detrendType = 'linear';
%% Read in the data and high-pass filter it.
for k = 1:length(inNames1)
    ext = inNames1{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    basename = inNames1{k}(1:(end-4));
    thisName = basename;
    fname = [inDir1 filesep inNames1{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g detrend, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.detrend, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outDir1 filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end

%%
for k = 1:length(inNames2)
    ext = inNames2{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    basename = inNames2{k}(1:(end-4));
    thisName = basename;
    fname = [inDir2 filesep inNames2{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf(['Computation times (seconds): %g resampling,' ...
             '%g detrend, %g line noise, %g reference \n'], ...
             computationTimes.resampling, computationTimes.detrend, ...
             computationTimes.lineNoise, computationTimes.reference);
    fname = [outDir2 filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end