%% Run the statistics for a version of the NCTU
pop_editoptions('option_single', false, 'option_savetwofiles', false);
issueFile = 'issues.txt';

%% Setup the directories and titles
ess2Dir = 'N:\ARLAnalysis\NCTU\NCTU_Robust_1Hz';
outDir = 'N:\ARLAnalysis\NCTU\NCTU_Robust_1Hz';
theTitle = 'NCTU_Robust_1Hz';

%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% Generate an issue report for the collection
[badFiles, badReasons] = getCollectionIssues(filenames);

%% Generate an issue report for the collection
fid = fopen([outDir filesep issueFile], 'w');
fprintf(fid, 'Issues for %s\n', theTitle);
if ~isempty(badFiles)
    for j = 1:length(badFiles)
        fprintf(fid, '%s\n   %s\n', badFiles{j}, badReasons{j});
    end
end
fclose(fid);


