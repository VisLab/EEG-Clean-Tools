%% Example: Running the pipeline outside of ESS using the ARL shooter data.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually.

%% Read in the file and set the necessary parameters
basename = 'TsLs_NBack';
%inDir = 'E:\CTAData\TsLs_Nback_setfiles'; % Input data directory used for this demo
inDir = 'O:\ARL_Data\TsLs_NBack\TsLs_NBack_Robust_1Hz';
%reportDir = 'O:\ARL_Data\TsLs_NBack\TsLs_NBack_Robust_1Hz_Report';
doReport = true;
publishOn = true;

%% Parameters that must be preset
params = struct();
%params.lineFrequencies = [60, 120, 180, 200, 212, 240];
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.keepFiltered = false;
params.referenceChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:64;
params.detrendChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.meanEstimateType = 'median';
params.interpolationOrder = 'post-reference';
params.keepFiltered = false;
params.ignoreBoundaryEvents = true;
basenameOut = [basename 'robust_1Hz_post_median_unfiltered'];

%% Get the directories
inList = dir(inDir);
dirNames = {inList(:).name};
dirTypes = [inList(:).isdir];
fileNames = dirNames(~dirTypes);

%% Run the pipeline
for k = 1:length(fileNames)
    [myPath, myName, myExt] = fileparts(fileNames{k});
    if ~strcmpi(myExt, '.set')
        continue;
    end
    thisName = [inDir filesep fileNames{k}];
    EEG = pop_loadset(thisName);
    chanlocs = EEG.chanlocs;
    params.name = myName;
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outDir filesep fileNames{k}];
    save(fname, 'EEG', '-mat', '-v7.3');
    if doReport
        [fpath, name, fext] = fileparts(thisName);
        sessionReportName = [name '.pdf'];
        sessionReport = [reportDir filesep sessionReportName];
        consoleFID = 1;
        publishPrepReport(EEG, summaryReport, sessionReport, consoleFID, ...
                          publishOn);
    end
end

