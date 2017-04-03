%% Example: Running the pipeline outside of ESS using the ARL shooter data.
% This data is organized into subdirectories by subject under the main
% input directory. The data is in raw format, but has the channel
% locations. However, the assignment to reference and evaluation channels
% has to be be done manually.

%% Read in the file and set the necessary parameters
basename = 'shooter';
% inDir = 'E:\CTADATA\Shooter\Level0'; % Input data directory used for this demo
% outDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_Clean_Unfiltered';
% dataDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_Clean_Unfiltered_Report';
% inDir = 'E:\CTADATA\Shooter\Level0'; % Input data directory used for this demo
% outDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_Blasst_Unfiltered';
% dataDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_Blasst_Unfiltered_Report';
inDir = 'E:\CTADATA\Shooter\Level0'; % Input data directory used for this demo
outDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_NoLine_Unfiltered';
dataDir = 'E:\CTADATA\Shooter\Shooter_Robust_1Hz_NoLine_Unfiltered_Report';
frontChop = 6;   % Chop all but 6 seconds from front of first event
backChop = 6;    % Chop all but 6 seconds from back of last event
doReport = true;
publishOn = true;
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
params.lineNoiseMethod = 'none';
params.lineFrequencies = [60, 100, 120, 180, 200, 240];
%% Parameters especially set for reduced threshold
params.fScanBandWidth = 2;
params.correlationThreshold = 0.35;

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
        EEG = pop_loadset(thisName);
        chanlocs = EEG.chanlocs;
        labels = {chanlocs.labels};
        x = strcmpi(labels,'A1') | strcmpi(labels, 'A2') | ...
            strcmpi(labels, 'HEOL') | strcmpi(labels, 'HEOR') | ...
            strcmpi(labels, 'VEOU') | strcmpi(labels, 'VEOL');
        badLabels = labels(x);
        fprintf('None EEG channels: ')
        for c = 1:length(badLabels)
            fprintf('%s ', badLabels{c});
        end
        fprintf('\n');
        chans = 1:length(chanlocs);
        params.referenceChannels = chans(~x);
        params.evaluationChannels = params.referenceChannels;
        params.rereferencedChannels = chans;
        params.detrendChannels = chans;
        params.lineNoiseChannels = chans;
        params.name = theName;
        fprintf('Original length: %g seconds\n', EEG.pnts/EEG.srate);
        % Chop the signal if it isn't eyes open or eyes closed
        if ~strcmpi(params.name, 'EC') && strcmpi(params.name, 'EO')
            [EEG, choppedFront, choppedBack] = chop(EEG, frontChop, backChop);
            fprintf('Chopped %g from front and %g from back, new length:%g\n', ...
                choppedFront, choppedBack, EEG.pnts/EEG.srate);
        else
            choppedFront = 0;
            choppedBack = 0;
        end
        [EEG, computationTimes] = prepPipeline(EEG, params);
        EEG.etc.noiseDetection.chopped = [choppedFront, choppedBack];
       
        fprintf('Computation times (seconds):\n   %s\n', ...
            getStructureString(computationTimes));
        fname = [outDir filesep theseNames{j}];
        save(fname, 'EEG', '-mat', '-v7.3');
        if doReport
            [fpath, name, fext] = fileparts(thisName);
            sessionReport = [dataDir filesep name '.pdf'];
            consoleFID = 1;
            publishPrepReport(EEG, summaryReport, ...
                sessionReport, consoleFID, publishOn);
        end
    end
end
