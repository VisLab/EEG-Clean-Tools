%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'N:\\ARLAnalysis\\NCTU\\Level2B'; % Input data directory used for this demo
saveFile = 'N:\\ARLAnalysis\\NCTU\\Level2B\\dataStatistics.mat';
collectionTitle = 'NCTU lane-keeping standard referenced';
numDatasets = 80;
%% Read in the NCTU preprocessed data and consolidate
dataTitles = cell(numDatasets, 1);
channels = zeros(numDatasets, 1);
statisticsTitles = extractReferenceStatistics();
statistics = zeros(length(dataTitles), length(statisticsTitles));
noisyChannels = cell(length(dataTitles), 1);
dCount = 0;
for k = 1:80
    dirName = [indir filesep 'session' filesep' num2str(k)];
    fileList = dir(dirName);
    in_names = {fileList(:).name};
    in_types = [fileList(:).isdir];
    in_names = in_names(~in_types);
    for j = 1:length(in_names)
        ext = in_names{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        dCount = dCount + 1;
        dataTitles{k} = in_names{j}(1:(end-4));
        fname = [dirName filesep in_names{j}];
        fprintf('%d[%d]: %s\n', k, j, fname);
        EEG = pop_loadset(fname);
        [~, statistics(dCount, :), noisyChannels(dCount)] = ...
                                        extractReferenceStatistics(EEG);
        channels(dCount) = size(EEG.data, 1);
    end
end
%% Consolidate the results in a single structure for comparative analysis
stdl2stats = struct('collectionTitle', [] , ...
                    'dataTitles', [], ...
                    'statisticsTitles', [], ...
                    'statistics', [], ...
                    'channels', [], ...
                    'noisyChannels', []);
stdl2stats.collectionTitle = collectionTitle;
stdl2stats.dataTitles = dataTitles;
stdl2stats.statisticsTitles = statisticsTitles;
stdl2stats.statistics = statistics;
stdl2stats.channels = channels;
stdl2stats.noisyChannels = noisyChannels;
%% Save the statistics in the specified file
save(saveFile, 'stdl2stats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(stdl2stats);

%%
saveFile1 = 'N:\\ARLAnalysis\\NCTU\\Level2C\\dataStatistics.mat';
saveFile2 = 'N:\\ARLAnalysis\\NCTU\\Level2B\\dataStatistics.mat';
load(saveFile1, '-mat');
st1 = stdl2stats;
load(saveFile2, '-mat');
st2 = stdl2stats;
%%
showReferenceStatistics(st2);
%%
%%
showReferencePairedStatistics(st1, st2)