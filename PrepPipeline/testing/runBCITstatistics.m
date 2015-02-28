%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
% inDir = 'N:\\ARL_BCIT_Program\\Level2A\\T1'; % Input data directory used for this demo
% saveFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T1\dataStatistics.mat';
% issueFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T1\\issues.txt';
% collectionTitle = 'BCIT standard referenced - T1';
% inDir = 'N:\\ARL_BCIT_Program\\Level2A\\T2'; % Input data directory used for this demo
% saveFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T2\\dataStatistics.mat';
% issueFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T2\\issues.txt';
% collectionTitle = 'BCIT standard referenced - T2';

inDir = 'N:\\ARL_BCIT_Program\\Level2A\\T3'; % Input data directory used for this demo
saveFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T3\\dataStatistics.mat';
issueFile = 'N:\\ARL_BCIT_Program\\Level2AReports\\T3\\issues.txt';
collectionTitle = 'BCIT standard referenced - T3';
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
inNames = inNames(validNames);

%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(collectionTitle, inNames);
%% Save the statistics in the specified file
save(saveFile, 'collectionStats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(collectionStats);

%% Generate an issue report for the collection
report = getCollectionIssues(collectionStats);

%% Generate an issue report for the collection
fid = fopen(issueFile, 'w');
fprintf(fid, '%s\n', report);
fclose(fid);
