%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Gather standard level
inDir = 'N:\\ARLAnalysis\\VEPStandardLevel2A';
%outdir = 'N:\\ARLAnalysis\\VEPOrdinaryLevel2A';
saveFile = 'N:\\ARLAnalysis\\VEPStandardLevel2AReports\\dataStatistics.mat';
issueFile = 'N:\\ARLAnalysis\\VEPStandardLevel2AReports\\issues.txt';
collectionTitle = 'VEP standard ref';
numDatasets = 18;

%% Get the directory list
inList = dir(inDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%% Take only the .set files
validNames = true(size(inNames));
for j = 1:length(inNames)
    ext = inNames{j}((end-3):end);
    if ~strcmpi(ext, '.set')
        validNames(j) = false;
    else
        inNames{j} = [inDir filesep inNames{j}];
    end
end
%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(collectionTitle, inNames);
%% Save the statistics in the specified file
save(saveFile, 'collectionStats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(collectionStats);
%% Generate an issue report for the collection
[badReport, badFiles] = getCollectionIssues(collectionStats);

%% Generate an issue report for the collection
fid = fopen(issueFile, 'w');
fprintf(fid, '%s\n', badReport);
fclose(fid);
% %% Consolidate the results in a single structure for comparative analysis
% ordl2stats = struct('collectionTitle', [] , ...
%                     'dataTitles', [], ...
%                     'statisticsTitles', [], ...
%                     'statistics', [], ...
%                     'channels', []);
% ordl2stats.collectionTitle = collectionTitle;
% ordl2stats.dataTitles = dataTitles;
% ordl2stats.statisticsTitles = statisticsTitles;
% ordl2stats.statistics = statistics;
% ordl2stats.channels = channels;
% 
% %% Save the statistics in the specified file
% save(saveFile, 'ordl2stats', '-v7.3');
% 
% %% Show ordinary level 2 statistics
% showReferenceStatistics(ordl2stats);
% 
% %% Show comparison between standard and ordinary
% showReferencePairedStatistics(ordl2stats, stdl2stats)