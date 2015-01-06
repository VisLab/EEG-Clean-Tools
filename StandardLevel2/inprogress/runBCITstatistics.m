%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
inDir = 'N:\\ARL_BCIT_Program\\Level2'; % Input data directory used for this demo
saveFile = 'N:\\ARL_BCIT_Program\\Level2\\dataStatistics1.mat';
issueFile = 'N:\\ARL_BCIT_Program\\Level2\\issues.txt';
collectionTitle = 'BCIT standard referenced';
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
% %%
% saveFile1 = 'N:\\ARLAnalysis\\NCTU\\Level2C\\dataStatistics.mat';
% saveFile2 = 'N:\\ARLAnalysis\\NCTU\\Level2B\\dataStatistics.mat';
% load(saveFile1, '-mat');
% st1 = stdl2stats;
% load(saveFile2, '-mat');
% st2 = stdl2stats;
% %%
% showReferenceStatistics(st2);
% %%
% %%
% showReferencePairedStatistics(st1, st2)