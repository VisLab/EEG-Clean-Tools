%% Gather the statistics for the NCTU data that has been robustly referenced
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';

%% Setup the directories
inDir = 'N:\\ARLAnalysis\\NCTU\\NCTURobust_1Hz_New';
outDir = 'N:\\ARLAnalysis\\NCTU\\NCTURobust_1Hz_New';
theTitle = 'NCTU_Robust_1Hz';
fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};
numDatasets = 80;
%% Read in the NCTU preprocessed data and consolidate
fileList = cell(numDatasets, 1);
for k = 1:numDatasets
    dirName = [inDir filesep 'session' filesep' num2str(k)];
    inList = dir(dirName);
    inNames = {inList(:).name};
    inTypes = [inList(:).isdir];
    inNames = inNames(~inTypes);
    for j = 1:length(inNames)
        ext = inNames{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        fileList{k} = [dirName filesep inNames{j}];
    end
end


%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(theTitle, fileList, fieldPath);
%% Save the statistics in the specified file
save([outDir filesep saveFile], 'collectionStats', '-v7.3');

%% Display the reference statistics
showNoisyStatistics(collectionStats);

