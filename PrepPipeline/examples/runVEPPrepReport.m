%% This script takes a directory of files that have been processed by PREP
% and produces reports.

%% Read in the file and set the necessary parameters
% Set these to your own folders before running.
dataDir = 'PATH_TO_PREP_OUTPUT';      % folder of PREP-processed .set files
summaryFolder = 'PATH_TO_REPORTS';    % folder for the summary and session reports
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
    fname = [dataDir filesep inNames{k}];
    load(fname, '-mat');
    sessionFileName = [summaryFolder filesep sessionReportName];
    consoleFID = 1;
    publishPrepReport(EEG, summaryFileName, sessionFileName, consoleFID, publishOn);
end