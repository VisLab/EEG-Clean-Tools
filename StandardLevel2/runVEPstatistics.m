%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Gather standard level
indir = 'N:\\ARLAnalysis\\VEPStandardLevel2M';
%outdir = 'N:\\ARLAnalysis\\VEPOrdinaryLevel2A';
saveFile = 'N:\\ARLAnalysis\\VEPStandardLevel2MReports\\dataStatistics.mat';
collectionTitle = 'VEP standard ref';
numDatasets = 18;
%% Read in the NCTU preprocessed data and consolidate
dataTitles = cell(numDatasets, 1);
channels = zeros(numDatasets, 1);
[~, statisticsTitles] = extractReferenceStatistics();
statistics = zeros(length(dataTitles), length(statisticsTitles));
fileList = dir(indir);
in_names = {fileList(:).name};
in_types = [fileList(:).isdir];
in_names = in_names(~in_types);
for k = 1:numDatasets
    ext = in_names{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    dataTitles{k} = in_names{k}(1:(end-4));
    fprintf('%d: %s\n', k, in_names{k});
    EEG = pop_loadset([indir filesep in_names{k}]);
    statistics(k, :) = extractReferenceStatistics(EEG);
    channels(k) = size(EEG.data, 1);
end

%% Consolidate the results in a single structure for comparative analysis
stdl2stats = struct('collectionTitle', [] , ...
                    'dataTitles', [], ...
                    'statisticsTitles', [], ...
                    'statistics', [], ...
                    'channels', []);
stdl2stats.collectionTitle = collectionTitle;
stdl2stats.dataTitles = dataTitles;
stdl2stats.statisticsTitles = statisticsTitles;
stdl2stats.statistics = statistics;
stdl2stats.channels = channels;
%% Save the statistics in the specified file
save(saveFile, 'stdl2stats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(stdl2stats);

%% Gather ordinary level

indir = 'N:\\ARLAnalysis\\VEPOrdinaryLevel2A';
saveFile = 'N:\\ARLAnalysis\\VEPOrdinaryLevel2AReports\\dataStatistics.mat';
collectionTitle = 'VEP ordinary ref';
numDatasets = 18;
%% Read in the NCTU preprocessed data and consolidate
dataTitles = cell(numDatasets, 1);
channels = zeros(numDatasets, 1);
[~, statisticsTitles] = extractReferenceStatistics();
statistics = zeros(length(dataTitles), length(statisticsTitles));
fileList = dir(indir);
in_names = {fileList(:).name};
in_types = [fileList(:).isdir];
in_names = in_names(~in_types);
for k = 1:numDatasets
    ext = in_names{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    dataTitles{k} = in_names{k}(1:(end-4));
    fprintf('%d: %s\n', k, in_names{k});
    EEG = pop_loadset([indir filesep in_names{k}]);
    statistics(k, :) = extractReferenceStatistics(EEG);
    channels(k) = size(EEG.data, 1);
end

%% Consolidate the results in a single structure for comparative analysis
ordl2stats = struct('collectionTitle', [] , ...
                    'dataTitles', [], ...
                    'statisticsTitles', [], ...
                    'statistics', [], ...
                    'channels', []);
ordl2stats.collectionTitle = collectionTitle;
ordl2stats.dataTitles = dataTitles;
ordl2stats.statisticsTitles = statisticsTitles;
ordl2stats.statistics = statistics;
ordl2stats.channels = channels;

%% Save the statistics in the specified file
save(saveFile, 'ordl2stats', '-v7.3');

%% Show ordinary level 2 statistics
showReferenceStatistics(ordl2stats);

%% Show comparison between standard and ordinary
showReferencePairedStatistics(ordl2stats, stdl2stats)