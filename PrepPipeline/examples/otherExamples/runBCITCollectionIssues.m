%% Run the statistics for a version of the NCTU
pop_editoptions('option_single', false, 'option_savetwofiles', false);
issueFile = 'issues.txt';

%% Setup the directories and titles
% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
% outDir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
% theTitle = 'X2 RSVP Expertise';

ess2Dir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';
outDir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';
theTitle = 'X1 Baseline RSVP';

% ess2Dir = 'N:\BCIT_ESS\X4 Advanced Guard Duty';
% outDir = 'N:\BCIT_ESS\X4 Advanced Guard Duty';
% theTitle = 'X4 Advanced Guard Duty';

% ess2Dir = 'N:\BCIT_ESS\X1 Baseline RSVP';
% outDir = 'N:\BCIT_ESS\X1 Baseline RSVP';
% theTitle = 'X1 Baseline RSVP';

% ess2Dir = 'N:\BCIT_ESS\Experiment XC Calibration Driving';
% outDir = 'N:\BCIT_ESS\Experiment XC Calibration Driving';
% theTitle = 'Experiment XC Calibration Driving';

% ess2Dir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';
% outDir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';
% theTitle = 'X3 Baseline Guard Duty';

% ess2Dir = 'N:\BCIT_ESS\Experiment X2 Traffic Complexity';
% outDir = 'N:\BCIT_ESS\Experiment X2 Traffic Complexity';
% theTitle = 'Experiment X2 Traffic Complexity';

% ess2Dir = 'N:\BCIT_ESS\Experiment X6 Speed Control';
% outDir = 'N:\BCIT_ESS\Experiment X6 Speed Control';
% theTitle = 'Experiment X6 Speed Control';

%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);


%% Generate an issue report for the collection
[badFiles, badReasons] = getCollectionIssues(filenames);

%% Generate an issue report for the collection
fid = fopen([outDir filesep issueFile], 'w');
fprintf(fid, 'Issues for %s\n', theTitle);
if ~isempty(badFiles)
    for j = 1:length(badFiles)
        fprintf(fid, '%s\n   %s\n', badFiles{j}, badReasons{j});
    end
end
fclose(fid);


