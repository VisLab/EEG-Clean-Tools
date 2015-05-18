%% Example: Computing statistics of high pass original data for BCI2000.
% The reference of the original data is unknown.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually.

%% Read in the file and set the necessary parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir = 'E:\BCIProcessing\BCI2000Set';
outDir = 'N:\BCI2000\BCI2000_1Hz';
basename = 'BCI2000';

%% Parameters that must be preset
params = struct();
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:64;
params.detrendChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'original-unknown';

%% Get a list of the top-level directories
inList = dir(inDir);
dirNames = {inList(:).name};
dirTypes = [inList(:).isdir];
dirNames = dirNames(dirTypes);
dirNames(strcmpi(dirNames, '.')| strcmpi(dirNames, '..')) = [];

%% Run the pipeline
for k = 1:length(dirNames)
    thisDir = [inDir filesep dirNames{k}];
    fprintf('Directory %d: %s\n', k, thisDir);
    thisList = dir(thisDir);
    theseNames = {thisList(:).name};
    theseTypes = [thisList(:).isdir];
    theseNames = theseNames(~theseTypes);
    for j = 1:length(theseNames)
        ext = theseNames{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        thisFile = [thisDir filesep theseNames{j}];
        thisName = theseNames{j}(1:end-4);
        fprintf('Subject %d [%d]: %s\n', k, j, theseNames{j})
        
        EEG = pop_loadset(thisFile);
        params.name = thisName;
        EEG.data = double(EEG.data);
        %         refSignal = nanmean(EEG.data(params.referenceChannels, :), 1);
        %         EEG = removeReference(EEG, refSignal, params.rereferencedChannels);
        [EEG, params.detrend]  = removeTrend(EEG, params);
        params.referenceSignal = [];
        params.noisyOut = findNoisyChannels(EEG, params);
        EEG.etc.originalReference = params;
        fname = [outDir filesep theseNames{j}];
        save(fname, 'EEG', '-mat', '-v7.3');
    end
end
