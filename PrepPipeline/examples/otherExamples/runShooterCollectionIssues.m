%% Generates an issue report for EEG structures that have been robustly referenced.
%
%  Assumes EEG is in a single directory.
pop_editoptions('option_single', false, 'option_savetwofiles', false);
issueFile = 'issues.txt';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', []);
setupDir(1).inDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered';
setupDir(1).outDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered_Report';
setupDir(1).title = 'Shooter_Robust_1Hz';

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
    fileList = inNames(validNames);
    %% Generate an issue report for the collection
    [badFiles, badReasons] = getCollectionIssues(fileList);

    %% Generate an issue report for the collection
    fid = fopen([setupDir(k).outDir filesep issueFile], 'w');
    fprintf(fid, 'Issues for %s\n', setupDir(k).title);
    if ~isempty(badFiles)
        for j = 1:length(badFiles)
           fprintf(fid, '%s\n   %s\n', badFiles{j}, badReasons{j});
        end
    end
    fclose(fid);
end
