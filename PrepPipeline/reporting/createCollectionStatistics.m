function collectionStats = ...
    createCollectionStatistics(collectionTitle, fileList, fieldPath)
% Extract collection statistics for EEG in fileList (full path file names)
collectionStats = struct('collectionTitle', [] , ...
                         'dataTitles', [], ...
                         'statisticsTitles', [], ...
                         'statistics', [], ...
                         'channels', [], ...
                         'noisyChannels', []);
[statisticsTitles, statisticsIndex, noisyStructure] = extractNoisyStatistics();
dataTitles = cell(length(fileList), 1);
channels = zeros(length(fileList), 1);
statistics = zeros(length(fileList), length(statisticsTitles));
noisyChannels(length(fileList)) = noisyStructure;
badFiles = {};
badReasons = {};
for k = 1:length(fileList)
    dataTitles{k} = fileList{k};
    try    % Ignore non EEG files
        fprintf('%d: ', k);
        EEG = pop_loadset(fileList{k});
        noisy = getFieldIfExists(EEG, fieldPath);
        [~, ~,  noisyChannels(k), statistics(k, :)] = ...
            extractNoisyStatistics(noisy);
        channels(k) = size(EEG.data, 1);
    catch Mex
        badFiles{end+1} = fileList{k}; %#ok<AGROW>
        badReasons{end+1} = Mex.message; %#ok<AGROW>
        continue;
    end   
end
%% Consolidate the results in a single structure for comparative analysis
collectionStats.collectionTitle = collectionTitle;
collectionStats.dataTitles = dataTitles;
collectionStats.statisticsTitles = statisticsTitles;
collectionStats.statisticsIndex = statisticsIndex;
collectionStats.statistics = statistics;
collectionStats.channels = channels;
collectionStats.noisyChannels = noisyChannels;
collectionStats.badFiles = badFiles;
collectionStats.badReasons = badReasons;