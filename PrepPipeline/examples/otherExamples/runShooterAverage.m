%% Example: Computing statistics of high pass with mastoid reference
% using the ARL shooter data.  The original data was mastoid-referenced.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually. We chop all but 6 seconds from before first
% event and after last event.

%% Read in the file and set the necessary parameters
basename = 'shooter';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir = 'E:\\CTAData\\Shooter\'; % Input data directory used for this demo
outDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Average_1Hz';
frontChop = 6;   % Chop all but 6 seconds from front of first event
backChop = 6;    % Chop all but 6 seconds from back of last event

%% Parameters that must be preset
params = struct();
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'average';

%% Get the directories
inList = dir(inDir);
dirNames = {inList(:).name};
dirTypes = [inList(:).isdir];
dirNames = dirNames(dirTypes);

%% Run the pipeline
count = 0;
for k = 1:length(dirNames)
    thisDir = [inDir filesep dirNames{k}];
    fprintf('Directory: %s\n', thisDir);
    thisList = dir(thisDir);
    theseNames = {thisList(:).name};
    theseTypes = [thisList(:).isdir];
    theseNames = theseNames(~theseTypes);
    for j = 1:length(theseNames)
        ext = theseNames{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        thisName = [thisDir filesep theseNames{j}];
        count = count + 1;
        fprintf('%d [%d}: %s\n', count, j, thisName);
        EEG = pop_loadset(thisName);
        chanlocs = EEG.chanlocs;
        labels = {chanlocs.labels};
        x = strcmpi(labels,'A1') | strcmpi(labels, 'A2') | ...
            strcmpi(labels, 'HEOL') | strcmpi(labels, 'HEOR') | ...
            strcmpi(labels, 'VEOU') | strcmpi(labels, 'VEOL');
        badLabels = labels(x);
        fprintf('None EEG channels: ')
        for c = 1:length(badLabels)
            fprintf('%s ', badLabels{c});
        end
        fprintf('\n');
        chans = 1:length(chanlocs);
        params.referenceChannels = chans(~x);
        params.evaluationChannels = params.referenceChannels;
        params.rereferencedChannels = chans;
        params.detrendChannels = chans;
        params.lineNoiseChannels = chans;
        params.name = thisName(1:end-4);
        fprintf('Original length: %g seconds\n', EEG.pnts/EEG.srate);
        [EEG, choppedFront, choppedBack] = chop(EEG, frontChop, backChop);
        fprintf('Chopped %g from front and %g from back, new length:%g\n', ...
            choppedFront, choppedBack, EEG.pnts/EEG.srate);
        EEG.data = double(EEG.data);
        refSignal = nanmean(EEG.data(params.referenceChannels, :), 1);
        EEG = removeReference(EEG, refSignal, params.rereferencedChannels);    
        [EEG, params.detrend]  = removeTrend(EEG, params);
        params.averageReference = refSignal;
        params.noisyOut = findNoisyChannels(EEG, params);
        EEG.etc.averageReference = params;
        fname = [outDir filesep theseNames{j}];
        save(fname, 'EEG', '-mat', '-v7.3');
    end
end
