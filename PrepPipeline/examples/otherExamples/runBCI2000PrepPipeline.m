%% Example: Running the pipeline on the BCI2000 data which is organized
% into subject directories beneath the main directory. We run the report
% along with the file
%% Set EEGLAB options for double precision
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Read in the file and set the necessary parameters
inDir = 'E:\BCIProcessing\BCI2000Set';
outDir = 'N:\BCI2000\BCI2000Robust_1Hz_Unfiltered';
dataDir = 'N:\BCI2000\BCI2000Robust_1Hz_Unfiltered_Report';
basename = 'BCI2000';
doReport = true;

%% Prepare if reporting
if doReport
    summaryReportName = [basename '_summary.html'];
    sessionFolder = '.';
    reportSummary = [dataDir filesep summaryReportName];
    if exist(reportSummary, 'file')
        delete(reportSummary);
    end
    summaryReportLocation = [dataDir filesep summaryReportName];
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
end

%% Parameters that must be preset
params = struct();
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:64;
params.detrendChannels = 1:64;
params.lineNoiseChannels = 1:64;
params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.keepFiltered = false;

%% Get a list of the top-level directories
inList = dir(inDir);
dirNames = {inList(:).name};
dirTypes = [inList(:).isdir];
dirNames = dirNames(dirTypes);
dirNames(strcmpi(dirNames, '.')| strcmpi(dirNames, '..')) = []; 

%% Run the pipeline
for k = 1:length(dirNames)
    thisDir = [inDir filesep dirNames{k}];
    fprintf('Directory %d: %s\n', k, thisDir);
    thisList = dir(thisDir);
    theseNames = {thisList(:).name};
    theseTypes = [thisList(:).isdir];
    theseNames = theseNames(~theseTypes);
    for j = 1:length(theseNames)
        ext = theseNames{j}((end-3):end);
        if ~strcmpi(ext, '.set')
            continue;
        end
        thisFile = [thisDir filesep theseNames{j}];
        thisName = theseNames{j}(1:end-4);
        fprintf('Subject %d [%d]: %s\n', k, j, theseNames{j})
        
        EEG = pop_loadset(thisFile);
        params.name = thisName;
        [EEG, computationTimes] = prepPipeline(EEG, params);
        fprintf('Computation times (seconds):\n   %s\n', ...
            getStructureString(computationTimes));
        fname = [outDir filesep theseNames{j}];
        save(fname, 'EEG', '-mat', '-v7.3');
        if doReport
            sessionReportName = [thisName '.pdf'];
            tempReportLocation = [dataDir filesep sessionFolder ...
                filesep 'prepPipelineReport.pdf'];
            actualReportLocation = [dataDir filesep sessionFolder ...
                filesep sessionReportName];
            
            relativeReportLocation = [sessionFolder filesep sessionReportName];
            consoleFID = 1;
            publishPrepPipelineReport(EEG, dataDir, summaryReportName, ...
                sessionFolder, sessionReportName, true);
        end
    end
end
fclose all;