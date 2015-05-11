%% Create composite data statistics and issues files for the VEP data
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';
issueFile = 'issues.txt';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', []);
setupDir(1).inDir = 'N:\\BCI2000Prep\\BCI2000Robust_Unfiltered';
setupDir(1).outDir = 'N:\\BCI2000Prep\\BCI2000Robust_Unfiltered_Report';
setupDir(1).title = 'BCI2000 robust';


%% Get the directory list
for k = 1:length(setupDir)
    inList = dir(setupDir(k).inDir);
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
            inNames{j} = [setupDir(k).inDir filesep inNames{j}];
        end
    end
    %% Consolidate the results in a single structure for comparative analysis
    collectionStats = createCollectionStatistics(setupDir(k).title, inNames);
    %% Save the statistics in the specified file
    save([setupDir(k).outDir filesep saveFile], 'collectionStats', '-v7.3');

    %% Display the reference statistics
    showReferenceStatistics(collectionStats);
    %% Generate an issue report for the collection
    [badReport, badFiles] = getCollectionIssues(collectionStats);

    %% Generate an issue report for the collection
    fid = fopen([setupDir(k).outDir filesep issueFile], 'w');
    fprintf(fid, '%s\n', badReport);
    fclose(fid);
    %close all
end
