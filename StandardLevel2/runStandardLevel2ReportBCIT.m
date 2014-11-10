%% Run through the high pass and look at the spectrum afterwards
datadir = 'N:\\Driving\\Level2';
summaryFolder = 'N:\\Driving\\Level2Reports';

basename = 'bcit';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary = [summaryFolder filesep summaryReportName];
if exist(reportSummary, 'file') 
   delete(reportSummary);
end
%% Get a list of the files in the driving data from level 1
in_list = dir(datadir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);

%% Run the pipeline
for k = 1:length(in_names)
    thisFile = in_names{k}(1:(end-4));
    fname = [datadir filesep in_names{k}];
    sessionReportName = [thisFile '.pdf'];
    load(fname, '-mat');
    publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                  sessionFolder, sessionReportName);
end
