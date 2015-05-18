%% Run the statistics for a version of the BCI2000
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';

%% Setup the directories and titles
setupDir(1) = struct('inDir', [], 'outDir', [], 'title', []);
% setupDir(1).inDir = 'N:\\BCI2000\\BCI2000Robust_1Hz_Unfiltered';
% setupDir(1).outDir = 'N:\\BCI2000\\BCI2000Robust_1Hz_Unfiltered_Report';
% setupDir(1).title = 'BCI2000 robust 1Hz unfiltered';
% setupDir(1).fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% setupDir(1).inDir = 'N:\\BCI2000\\BCI2000_Average_1Hz';
% setupDir(1).outDir = 'N:\\BCI2000\\BCI2000_Average_1Hz_Report';
% setupDir(1).title = 'BCI2000 average 1Hz';
% setupDir(1).fieldPath = {'etc', 'averageReference', 'noisyOut'};

setupDir(1).inDir = 'N:\\BCI2000\\BCI2000_1Hz';
setupDir(1).outDir = 'N:\\BCI2000\\BCI2000_1Hz_Report';
setupDir(1).title = 'BCI2000 1Hz';
setupDir(1).fieldPath = {'etc', 'originalReference', 'noisyOut'};

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
