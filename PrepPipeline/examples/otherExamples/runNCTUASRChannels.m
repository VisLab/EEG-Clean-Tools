%% Example using ESS
pop_editoptions('option_single', false, 'option_savetwofiles', false);
ess2Dir = 'N:\\ARLAnalysis\\NCTUPrep\\NCTU_LK_Level_2_Unfiltered';
%ess2Dir = 'N:\\ARLAnalysis\\NCTUPrepPreSession13\\NCTURobustHP1Hz';
ess2File = 'studyLevel2_description.xml';
ess2DirNew = 'N:\\ARLAnalysis\\NCTUPrep\\NCTU_LK_Level_2_ASR';

%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% Extract the channel locations
channelsToBeRemoved = upper({'A1', 'A2'});
channelsToBeIgnored = upper({'vehicle position'});
for k = 1:length(filenames)
    %% Load the data
    EEG = pop_loadset(filenames{k});
    %% Set the urchanlocs if not already set
    if isempty(EEG.urchanlocs)
        EEG.urchanlocs = EEG.chanlocs;
    end
 
    %% Get rid of the channels which will be permanently removed
    channelLabels = upper({EEG.chanlocs.labels});
    [rchans, aIndRem, bIndRem] = intersect(channelLabels, channelsToBeRemoved);
    
    if ~isempty(aIndRem)
        EEG.chanlocs(aIndRem) = [];
        EEG.nbchan = length(EEG.chanlocs);
        EEG.data(aIndRem, :) = [];
    end
    
    %%  Temporarily remove channels to be ignored
    EEG1 = EEG;
    channelLabels = upper({EEG1.chanlocs.labels});
    [ichans, aIndIg, bIndIg] = intersect(channelLabels, channelsToBeIgnored);
    if ~isempty(aIndIg)
        EEG1.chanlocs(aIndIg) = [];
        EEG1.nbchan = length(EEG1.chanlocs);
        EEG1.data(aIndIg, :) = [];
    end
    
    %%  Use ASR to remove the bursts
    EEG1 = clean_rawdata(EEG1, 5, [0.25 0.75], -1, -1, 20, -1);
    
    %%  Reinsert the cleaned data into the EEG
    actualChannels = 1:length(EEG.chanlocs);
    [mappedChannels, aIndMap] = setdiff(actualChannels, aIndIg);
    EEG.data(aIndMap, :) = EEG1.data;
    asr = struct('ASRChannels', mappedChannels, ...
                 'ASRFilter', 'clean_rawdata(EEG, 5, [0.25 0.75], -1, -1, 20, -1)', ...
                 'ASRVersion', '0.13');
    EEG.etc.noiseDetection.asr = asr;
    [pathName, thisName, ext] = fileparts(filenames{k});
    fname = [ess2DirNew filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3'); 
end

