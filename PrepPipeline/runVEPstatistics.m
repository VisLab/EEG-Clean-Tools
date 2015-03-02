%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';
issueFile = 'issues.txt';

%% Setup the directories and titles
setupDir(3) = struct('inDir', [], 'outDir', [], 'title', []);
setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz';
setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz_Report';
setupDir(1).title = 'VEP robust';

setupDir(2).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz';
setupDir(2).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz_Report';
setupDir(2).title = 'VEP mastoid';

setupDir(3).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz';
setupDir(3).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz_Report';
setupDir(3).title = 'VEP average';


% setupDir(2).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrended';
% setupDir(2).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports';
% setupDir(2).title = 'VEP d-robust';
% 
% setupDir(3).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5';
% setupDir(3).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5Reports';
% setupDir(3).title = 'VEP d-robust-0.5';
% 
% setupDir(4).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p5';
% setupDir(4).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p5Reports';
% setupDir(4).title = 'VEP robust-0.5';
% 
% setupDir(5).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3';
% setupDir(5).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3Reports';
% setupDir(5).title = 'VEP d-robust-0.3';
% 
% setupDir(6).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3';
% setupDir(6).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3Reports';
% setupDir(6).title = 'VEP robust-0.3';
% 
% setupDir(7).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2';
% setupDir(7).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2Reports';
% setupDir(7).title = 'VEP d-robust-0.2';
% 
% setupDir(8).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrended';
% setupDir(8).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrendedReports';
% setupDir(8).title = 'VEP md-robust';
% 
% setupDir(9).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrended';
% setupDir(9).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrendedReports';
% setupDir(9).title = 'VEP d-mastoid';
% 
% setupDir(10).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrended';
% setupDir(10).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrendedReports';
% setupDir(10).title = 'VEP md-before';
% 
% setupDir(11).inDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrended';
% setupDir(11).outDir = 'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrendedReports';
% setupDir(11).title = 'VEP d-average';

%% Get the directory list
for k = 2%1:length(setupDir)
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
