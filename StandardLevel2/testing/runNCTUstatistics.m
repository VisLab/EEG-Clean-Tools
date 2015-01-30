%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
% indir = 'N:\\ARLAnalysis\\NCTU\\Level2'; % Input data directory used for this demo
% saveFile = 'N:\\ARLAnalysis\\NCTU\\Level2\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\NCTU\\Level2\\issues.txt';
% collectionTitle = 'NCTU lane-keeping standard referenced';

% indir = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2Average'; % Input data directory used for this demo
% saveFile = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2Average\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2Average\\issues.txt';
% collectionTitle = 'NCTU lane-keeping average referenced';

indir = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2MastoidBefore'; % Input data directory used for this demo
saveFile = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2MastoidBefore\\dataStatistics.mat';
issueFile = 'N:\\ARLAnalysis\\NCTU\\SpecificLevel2MastoidBefore\\issues.txt';
collectionTitle = 'NCTU lane-keeping mastoid before';
numDatasets = 80;
%% Read in the NCTU preprocessed data and consolidate
fileList = cell(numDatasets, 1);
for k = 1:numDatasets
    dirName = [indir filesep 'session' filesep' num2str(k)];
    inList = dir(dirName);
    in_names = {inList(:).name};
    in_types = [inList(:).isdir];
    in_names = in_names(~in_types);
    for j = 1:length(in_names)
        ext = in_names{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        fileList{k} = [dirName filesep in_names{j}];
    end
end
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
