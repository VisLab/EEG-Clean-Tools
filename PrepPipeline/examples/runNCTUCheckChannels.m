%% Example using ESS
ess2Dir = 'N:\\ARLAnalysis\\NCTUPrep\\NCTU_LK_STLD2_Unfiltered';
%ess2Dir = 'N:\\ARLAnalysis\\NCTUPrepPreSession13\\NCTURobustHP1Hz';
ess2File = 'studyLevel2_description.xml';

%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% Extract the channel locations
channelLocations = cell(length(filenames), 1);
for k = 1:length(filenames)
    EEG = pop_loadset(filenames{k});
    channelLocations{k} = EEG.chanlocs;
end

%% Look at the different labels
chanlabelsUnion = upper({channelLocations{1}.labels});
chanlabelsInter = upper({channelLocations{1}.labels});
for k = 2:length(channelLocations)
    chanlabelsUnion = union(chanlabelsUnion, upper({channelLocations{k}.labels}));
    chanlabelsInter = intersect(chanlabelsInter, upper({channelLocations{k}.labels}));
end

%% Look at only the ones using the 10-20 system
chanlabels10_20 = {};
for k = 1:length(channelLocations)
    if strcmpi(subjects(k).channelLocations, 'NA')
        chanlabels10_20 = union(chanlabels10_20, upper({channelLocations{k}.labels}));
    end
end

%%
k = 1;
[X1, A1, B1] = intersect(upper({channelLocations{k}.labels}), chanlabelsInter);

%%
c = channelLocations{k};
%%
x = cell2mat({channelLocations{k}.X}')
%%
[X2, A2, B2] = intersect(chanlabels, upper({channelLocations{k}.labels}));