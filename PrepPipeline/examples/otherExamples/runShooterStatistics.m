%% Run the statistics for a version of the Shooter
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', []);
setupDir(1).inDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered';
setupDir(1).outDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Robust_1Hz_Unfiltered_Report';
setupDir(1).title = 'Shooter_Robust_1Hz';
setupDir(1).fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% setupDir(1).inDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Average_1Hz';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Average_1Hz_Report';
% setupDir(1).title = 'Shooter_Average_1Hz';
% setupDir(1).fieldPath = {'etc', 'averageReference', 'noisyOut'};
% 
% setupDir(1).inDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Mastoid_1Hz';
% setupDir(1).outDir = 'N:\\ARLAnalysis\\Shooter\\Shooter_Mastoid_1Hz_Report';
% setupDir(1).title = 'Shooter_Mastoid_1Hz';
% setupDir(1).fieldPath = {'etc', 'mastoidReference', 'noisyOut'};

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
