function [collections, collectionStats] = getCollections(collectionFiles)
% Return a cell array of collections and a structure of statistics
collections = cell(length(collectionFiles), 1);
for k = 1:length(collections)
    fprintf('%d: %s\n', k, collectionFiles{k});
    x = load(collectionFiles{k});
    xName = fieldnames(x);
    collections{k} = x.(xName{1});
end
s = collections{1}.statisticsIndex;

%% Calculate the window ref sdr/med window channel deviations
refRatiosDev = cell(length(collections), 1);
for k = 1:length(collections)
    refRatiosDev{k} = collections{k}.statistics(:, s.rSDDevRef)./ ...
        collections{k}.statistics(:, s.medDevRef);
end;

refRatiosWinDev = cell(length(collections), 1);
for k = 1:length(collections)
    refRatiosWinDev{k} = collections{k}.statistics(:, s.rSDWinDevRef)./ ...
        collections{k}.statistics(:, s.medWinDevRef);
end;

origRatiosWinDev = cell(length(collections), 1);
for k = 1:length(collections)
    origRatiosWinDev{k} = collections{k}.statistics(:, s.rSDWinDevOrig)./ ...
        collections{k}.statistics(:, s.medWinDevOrig);
end;

refRatiosHF = cell(length(collections), 1);
for k = 1:length(collections)
    refRatiosHF{k} = collections{k}.statistics(:, s.rSDHFRef)./ ...
        collections{k}.statistics(:, s.medHFRef);
end;

refRatiosWinHF = cell(length(collections), 1);
for k = 1:length(collections)
    refRatiosWinHF{k} = collections{k}.statistics(:, s.rSDWinHFRef)./ ...
        collections{k}.statistics(:, s.medWinHFRef);
end;

refCorr = cell(length(collections), 1);
for k = 1:length(collections)
    refCorr{k} = collections{k}.statistics(:, s.aveCorRef);
end;

refDev = cell(length(collections), 1);
for k = 1:length(collections)
    refDev{k} = collections{k}.statistics(:, s.medDevRef);
end;

refWinDev = cell(length(collections), 1);
for k = 1:length(collections)
    refWinDev{k} = collections{k}.statistics(:, s.medWinDevRef);
end;

origWinDev = cell(length(collections), 1);
for k = 1:length(collections)
    origWinDev{k} = collections{k}.statistics(:, s.medWinDevOrig);
end;

refHF = cell(length(collections), 1);
for k = 1:length(collections)
    refHF{k} = collections{k}.statistics(:, s.medHFRef);
end;

refWinHF = cell(length(collections), 1);
for k = 1:length(collections)
    refWinHF{k} = collections{k}.statistics(:, s.medWinHFRef);
end;

%% Consolidate the statistics
collectionStats = struct('refRatiosDev', [], 'refRatiosWinDev', [], ...
                         'origRatiosWinDev', [], ...
                         'refRatiosHF', [], 'refRatiosWinHF', [], ...
                         'refCorr', [], ...
                         'refDev', [], 'refWinDev', [], 'origWinDev', [],...
                         'refHF', [], 'refWinHF', []);
collectionStats.refRatiosDev = refRatiosDev;
collectionStats.refRatiosWinDev = refRatiosWinDev;
collectionStats.origRatiosWinDev = origRatiosWinDev;
collectionStats.refRatiosHF = refRatiosHF;
collectionStats.refRatiosWinHF = refRatiosWinHF;
collectionStats.refCorr = refCorr;
collectionStats.refDev = refDev;
collectionStats.refWinDev = refWinDev;
collectionStats.origWinDev = origWinDev;
collectionStats.refHF = refHF;
collectionStats.refWinHF = refWinHF;

