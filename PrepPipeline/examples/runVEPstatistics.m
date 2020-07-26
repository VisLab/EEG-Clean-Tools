%% Run the statistics for a version of the VEP 
saveFile = 'dataStatistics.mat';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', [], 'fieldPath', []);
setupDir(1).inDir = 'N:\ARLAnalysis\VEP\VEPRobust_1Hz_Post_Median_Unfiltered';
setupDir(1).outDir = 'N:\ARLAnalysis\VEP\VEPRobust_1Hz_Post_Median_Unfiltered_Report';
setupDir(1).title = 'VEP robust 1Hz';
setupDir(1).fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};
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
    collectionStats = createCollectionStatistics(setupDir(k).title, ...
                                          inNames, setupDir(k).fieldPath);
    %% Save the statistics in the specified file
    save([setupDir(k).outDir filesep saveFile], 'collectionStats', '-v7.3');

    %% Display the reference statistics
    showNoisyStatistics(collectionStats);
end
