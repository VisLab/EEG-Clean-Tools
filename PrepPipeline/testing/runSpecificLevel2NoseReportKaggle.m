%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
dataDir1 = 'N:\\ARLAnalysis\\KaggleBCI\\train';
dataDir2 = 'N:\\ARLAnalysis\\KaggleBCI\\test';
summaryFolder1 = 'N:\\ARLAnalysis\\KaggleBCI\\reports\\train';
summaryFolder2 = 'N:\\ARLAnalysis\\KaggleBCI\\reports\\test';
%% Get a list of the files in the driving data from level 1
inList1 = dir(dataDir1);
inNames1 = {inList1(:).name};
inTypes1 = [inList1(:).isdir];
inNames1 = inNames1(~inTypes1);
inList2 = dir(dataDir2);
inNames2 = {inList2(:).name};
inTypes2 = [inList2(:).isdir];
inNames2 = inNames2(~inTypes2);
%% Set up basenames
basename = 'kaggle';
summaryReportName = [basename '_summary.html'];
sessionFolder = '.';
reportSummary1 = [summaryFolder1 filesep summaryReportName];
if exist(reportSummary1, 'file') 
   delete(reportSummary1);
end
reportSummary2 = [summaryFolder2 filesep summaryReportName];
if exist(reportSummary2, 'file') 
   delete(reportSummary2);
end

%% Run the pipeline
for k = 1:length(inNames1)
    thisFile = inNames1{k}(1:(end-4));
    fname = [dataDir1 filesep inNames1{k}];
    sessionReportName = [thisFile '.pdf'];
    load(fname, '-mat');
    publishLevel2Report(EEG, summaryFolder1, summaryReportName, ...
                  sessionFolder, sessionReportName);
end

for k = 1:length(inNames2)
    thisFile = inNames2{k}(1:(end-4));
    fname = [dataDir2 filesep inNames2{k}];
    sessionReportName = [thisFile '.pdf'];
    load(fname, '-mat');
    publishLevel2Report(EEG, summaryFolder2, summaryReportName, ...
                  sessionFolder, sessionReportName);
end
