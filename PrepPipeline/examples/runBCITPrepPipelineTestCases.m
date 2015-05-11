%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

indir = 'E:\\BCIT_Test_Cases';
outdir = 'N:\\BCIT_Test_Cases';
datadir = 'N:\\BCIT_Test_Cases_Report';
basename = 'BCIT_Tests';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [datadir filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end
summaryReportLocation = [datadir filesep summaryReportName];
summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
params = struct();

params.detrendType = 'high pass';
params.detrendCutoff = 1;
params.referenceType = 'robust';
params.keepFiltered = false;
%% Get a list of the files in the driving data from level 1
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);
params.lineFrequencies = [60, 120, 180, 240, 360, 420, 480];

%% Read in the data and high-pass filter it.
for k = 1:length(in_names)
    [myPath, myName, myExt] = fileparts(in_names{k});
    if ~strcmpi(myExt, '.set')
        continue;
    end
    basename = myName;
    thisName = basename;
    fname = [indir filesep in_names{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    chanblk = 32* floor(size(EEG.data, 1)/32);
    params.name = thisName;
    params.referenceChannels = 1:chanblk;
    params.evaluationChannels = 1:chanblk;
    params.rereferencedChannels = 1:(chanblk+6);
    params.detrendChannels = 1:(chanblk+6);
    params.lineNoiseChannels = 1:(chanblk+6);
    [EEG, computationTimes] = prepPipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
    sessionReportName = [thisName '.pdf'];
    tempReportLocation = [datadir filesep sessionFolder ...
        filesep 'prepPipelineReport.pdf'];
    actualReportLocation = [datadir filesep sessionFolder ...
        filesep sessionReportName];
    
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepPipelineReport(EEG, datadir, summaryReportName, ...
        sessionFolder, sessionReportName, true);
end