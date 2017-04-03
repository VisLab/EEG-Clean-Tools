%% Example: Running the pipeline outside of ESS using the ARL shooter data.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually.

%% Read in the file and set the necessary parameters
basename = 'BCI2000';
inDir = 'J:\CTAData\RestingDataCollection\BCI2000\Level0'; % Input data directory used for this demo
outDir = 'J:\CTAData\RestingDataCollection\BCI2000\BCI2000_Robust_Clean_1Hz_Unfiltered';
dataDir = 'J:\CTAData\RestingDataCollection\BCI2000\BCI2000_Robust_Clean_1Hz_Unfiltered_Report';
publishOn = true;
doReport = true;
%% Prepare if reporting
if doReport
    summaryReportName = [basename '_summary.html'];
    sessionFolder = '.';
    summaryReport = [dataDir filesep summaryReportName];
    if exist(summaryReport, 'file')
        delete(summaryReport);
    end
end
%% Parameters that must be preset
params = struct();
%params.lineFrequencies = [60, 120, 180, 200, 212, 240];
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.keepFiltered = false;
params.lineNoiseMethod = 'clean';

%% Parameters especially set for reduced threshold
params.fScanBandWidth = 2;

%% Get the directories
inList = dir(inDir);
dirNames = {inList(:).name};
dirTypes = [inList(:).isdir];
dirNames = dirNames(dirTypes);
dirNames(strcmpi(dirNames, '.')| strcmpi(dirNames, '..')) = [];

%% Run the pipeline
count = 0;
for k = 1:length(dirNames)
    thisDir = [inDir filesep dirNames{k}];
    fprintf('Directory: %s\n', thisDir);
    thisList = dir(thisDir);
    theseNames = {thisList(:).name};
    theseTypes = [thisList(:).isdir];
    theseNames = theseNames(~theseTypes);
    for j = 1:length(theseNames)
        [thePath, theName, theExt] = fileparts(theseNames{j});
        if ~strcmpi(theExt, '.set')
            continue;
        end
        thisName = [thisDir filesep theseNames{j}];
        count = count + 1;
        fprintf('%d [%d}: %s\n', count, j, thisName);
        params.name = theName;
        EEG = pop_loadset(thisName);

        [EEG, computationTimes] = prepPipeline(EEG, params);
        fprintf('Computation times (seconds):\n   %s\n', ...
            getStructureString(computationTimes));
        fname = [outDir filesep theseNames{j}];
        save(fname, 'EEG', '-mat', '-v7.3');
        if doReport
            sessionReport = [dataDir filesep theName '.pdf'];
            consoleFID = 1;
            publishPrepReport(EEG, summaryReport, ...
                sessionReport, consoleFID, publishOn);
        end
    end
end
