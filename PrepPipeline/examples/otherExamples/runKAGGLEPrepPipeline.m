%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir1 = 'E:\\CTAData\\KaggleBCI\\train'; % Input data directory used for this demo
inDir2 = 'E:\\CTAData\\KaggleBCI\\test'; % Input data directory used for this demo
outDir1 = 'N:\\ARLAnalysis\\KaggleBCIPrep\\train';
outDir2 = 'N:\\ARLAnalysis\\KaggleBCIPrep\\test';
%% Get a list of the files from the testing and training directory
inList1 = dir(inDir1);
inNames1 = {inList1(:).name};
inTypes1 = [inList1(:).isdir];
inNames1 = inNames1(~inTypes1);
inList2 = dir(inDir2);
inNames2 = {inList2(:).name};
inTypes2 = [inList2(:).isdir];
inNames2 = inNames2(~inTypes2);
%% Set the parameters
params = struct();
params.lineFrequencies = [50, 60, 100, 120, 180, 240, 300];
params.lineNoiseChannels = 1:56;
params.highPassChannels = 1:56;
params.referenceChannels = 1:56;
params.evaluationChannels = 1:56;
params.rereferenceChannels = 1:56;
params.detrendChannels = 1:56;
params.detrendCutoff = 1;
params.detrendType = 'high pass';
parameters.keepFiltered = 'false';

%% Process the data in the training set
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
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outDir1 filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end

%% Process the data in the test set
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
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outDir2 filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end