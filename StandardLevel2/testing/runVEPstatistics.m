%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';
issueFile = 'issues.txt';

%% Setup the directories and titles
setupDir(6) = struct('inDir', [], 'outDir', [], 'title', []);
setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2Robust';
setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2RobustReports';
setupDir(1).title = 'VEP robust';

setupDir(2).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobust';
setupDir(2).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobustReports';
setupDir(2).title = 'VEP m-robust';

setupDir(3).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2Mastoid';
setupDir(3).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidReports';
setupDir(3).title = 'VEP mastoid';

setupDir(4).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBefore';
setupDir(4).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeReports';
setupDir(4).title = 'VEP m-before';

setupDir(5).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2Average';
setupDir(5).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReports';
setupDir(5).title = 'VEP average';

setupDir(6).inDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverage';
setupDir(6).outDir = 'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverageReports';
setupDir(6).title = 'VEP m-average';


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
end
