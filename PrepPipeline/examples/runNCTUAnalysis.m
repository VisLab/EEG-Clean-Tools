%% Example using ESS
pop_editoptions('option_single', false, 'option_savetwofiles', false);
ess2Dir = 'N:\ARLAnalysis\\NCTUPrep\\NCTUStandardized';
ess2File = [ess2Dir filesep 'studyLevel2_description.xml'];
saveFile = 'N:\\ARLAnalysis\\NCTUPrep\\NCTURobustHP1Hz\\dataStatistics.mat';
issueFile = 'N:\\ARLAnalysis\\NCTUPrep\\NCTURobustHP1Hz\\issues.txt';
collectionTitle = 'NCTU lane-keeping robust HP 1 Hz';
numDatasets = 80;
%%  Load a level 2 ESS study for analysis
obj2 = level2Study('level2XmlFilePath', ess2File);
obj2.validate();

%% Get the information
[fileList, Uuids, taskLabels, sessionNumbers, subjects] = obj2.getFilename();
uniqueTasks = unique(taskLabels);

%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(collectionTitle, fileList);
%% Save the statistics in the specified file
save(saveFile, 'collectionStats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(collectionStats);
%% Generate an issue report for the collection
[reportBad, badFiles] = getCollectionIssues(collectionStats);

%% Generate an issue report for the collection
fid = fopen(issueFile, 'w');
fprintf(fid, '%s\n', reportBad);
fclose(fid);

%% 