%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Gather standard level
% inDir = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2';
% saveFile = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2Reports\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2Reports\\issues.txt';
% collectionTitle = 'VEP standard level 2';

% inDir = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2MastoidReference';
% saveFile = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2MastoidReferenceReports\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2MastoidReferenceReports\\issues.txt';
% collectionTitle = 'VEP standard ref - mastoid average removed';

% inDir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReference';
% saveFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports\\issues.txt';
% collectionTitle = 'VEP mastoid referenced';

% inDir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidBefore';
% saveFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidBeforeReports\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidBeforeReports\\issues.txt';
% collectionTitle = 'VEP mastoid before processing';

% inDir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReference';
% saveFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceReports\\dataStatistics.mat';
% issueFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceReports\\issues.txt';
% collectionTitle = 'VEP average referenced';

inDir = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoid';
saveFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoidReports\\dataStatistics.mat';
issueFile = 'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoidReports\\issues.txt';
collectionTitle = 'VEP average referenced - after Mastoid removed';

%% Get the directory list
inList = dir(inDir);
inNames = {inList(:).name};
inTypes = [inList(:).isdir];
inNames = inNames(~inTypes);

%% Take only the .set files
validNames = true(size(inNames));
for j = 1:length(inNames)
    ext = inNames{j}((end-3):end);
    if ~strcmpi(ext, '.set')
        validNames(j) = false;
    else
        inNames{j} = [inDir filesep inNames{j}];
    end
end
%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(collectionTitle, inNames);
%% Save the statistics in the specified file
save(saveFile, 'collectionStats', '-v7.3');

%% Display the reference statistics
showReferenceStatistics(collectionStats);
%% Generate an issue report for the collection
[badReport, badFiles] = getCollectionIssues(collectionStats);

%% Generate an issue report for the collection
fid = fopen(issueFile, 'w');
fprintf(fid, '%s\n', badReport);
fclose(fid);
