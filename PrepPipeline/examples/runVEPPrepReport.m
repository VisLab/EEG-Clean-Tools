%% This script takes a directory of files that have been processed by PREP
% and produces reports.

%% Read in the file and set the necessary parameters
% By default this reports on the output of runVEPPrepPipeline in
% examples/output. Change these to use your own folders.
exampleDir = fileparts(mfilename('fullpath'));
dataDir = fullfile(exampleDir, 'output');              % PREP-processed .set files
summaryFolder = fullfile(exampleDir, 'output', 'reports');  % summary and session reports
if ~exist(summaryFolder, 'dir')
    mkdir(summaryFolder);
end
publishOn = true;

%% Get the directory list
inList = dir(dataDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%% Setup up the names
basename = 'vep';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
summaryFileName = [summaryFolder filesep summaryReportName];
if exist(summaryFileName, 'file') 
   delete(summaryFileName);
end

%% Publish the reports
for k = 1:length(inNames)
    [~, theName, theExt] = fileparts(inNames{k});
    if ~strcmpi(theExt, '.set') && ~strcmpi(theExt, '.mat')
        continue;
    end
    sessionReportName = [theName '.pdf'];
    EEG = pop_loadset('filename', inNames{k}, 'filepath', dataDir);
    EEG.data = double(EEG.data);   % PREP reporting needs double precision
    sessionFileName = [summaryFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepReport(EEG, summaryFileName, sessionFileName, consoleFID, publishOn);
end