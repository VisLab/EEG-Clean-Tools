%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';
issueFile = 'issues.txt';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', []);
% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered_Report';
% setupDir(1).title = 'VEP robust unfiltered';
% 
% setupDir(2).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_UnfilteredOld';
% setupDir(2).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered_ReportOld';
% setupDir(2).title = 'VEP robust unfiltered old';
% 
% setupDir(3).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PostInterp_Unfiltered';
% setupDir(3).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PostInterp_Unfiltered_Report';
% setupDir(3).title = 'VEP robust post-interpolated unfiltered';
% 
% setupDir(4).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PreInterp_Unfiltered';
% setupDir(4).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PreInterp_Unfiltered_Report';
% setupDir(4).title = 'VEP robust pre-interpolated unfiltered';
% 
% setupDir(5).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered';
% setupDir(5).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered_Report';
% setupDir(5).title = 'VEP robust pre-interpolated unfiltered';
% 
% setupDir(6).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered_Test';
% setupDir(6).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered_Report_Test';
% setupDir(6).title = 'VEP robust pre-interpolated unfiltered_test';
% 
% setupDir(7).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PreInterp_Unfiltered_Test';
% setupDir(7).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PreInterp_Unfiltered_Report_Test';
% setupDir(7).title = 'VEP robust pre-interpolated unfiltered_test';

% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTest';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTestReport';
% setupDir(1).title = 'VEP robust pre-interpolated huber unfiltered_test';
% 
% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTest';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPTestReport';
% setupDir(1).title = 'VEP robust pre-interpolated huber unfiltered_test';

% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_Unfiltered';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_Unfiltered_Report';
% setupDir(1).title = 'VEP robust pro-interpolated median unfiltered';

% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_0p3Hz_Unfiltered';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_0p3Hz_Unfiltered_Report';
% setupDir(1).title = 'VEP robust pro-interpolated median 0.3Hz unfiltered';

% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_1Hz_Unfiltered';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_1Hz_Unfiltered_Report';
% setupDir(1).title = 'VEP robust pro-interpolated median 1 Hz unfiltered';
% setupDir(3) = struct('inDir', [], 'outDir', [], 'title', []);
% setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP1Hz_Report';
% setupDir(1).title = 'VEP robust';
% 
% setupDir(2).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP0p3Hz';
% setupDir(2).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPRobustHP0p3Hz_Report';
% setupDir(2).title = 'VEP robust 0.3Hz';
% 
% setupDir(3).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz';
% setupDir(3).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPAverageHP1Hz_Report';
% setupDir(3).title = 'VEP average';
% 
% setupDir(4).inDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz';
% setupDir(4).outDir = 'N:\\ARLAnalysis\\VEPPrep\\VEPMastoidHP1Hz_Report';
% setupDir(4).title = 'VEP mastoid';

setupDir(1).inDir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered';
setupDir(1).outDir = 'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered_Report';
setupDir(1).title = 'VEP robust 1 Hz post median';

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
