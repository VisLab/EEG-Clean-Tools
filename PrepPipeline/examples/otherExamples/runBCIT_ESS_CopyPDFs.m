%% Setup the directories and titles
ess2Dir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
outDir = 'O:\ARL_Data\BCIT_ESS_256Hz\X2 RSVP Expertise';
theTitle = 'X2 RSVP Expertise';

% ess2Dir = 'N:\BCIT_ESS\X1 Baseline RSVP';
% outDir = 'N:\BCIT_ESS_RESAMPLED\X1 Baseline RSVP';
% theTitle = 'X1 Baseline RSVP';

% ess2Dir = 'N:\BCIT_ESS\Experiment X2 Traffic Complexity';
% outDir = 'N:\BCIT_ESS_RESAMPLED\Experiment X2 Traffic Complexity';
% theTitle = 'Experiment X2 Traffic Complexity';

% ess2Dir = 'N:\BCIT_ESS\Experiment X6 Speed Control';
% outDir = 'N:\BCIT_ESS_RESAMPLED\Experiment X6 Speed Control';
% theTitle = 'Experiment X6 Speed Control';

% ess2Dir = 'N:\BCIT_ESS\Experiment XC Calibration Driving';
% outDir = 'N:\BCIT_ESS_RESAMPLED\Experiment XC Calibration Driving';
% theTitle = 'Experiment XC Calibration Driving';

% ess2Dir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';
% outDir = 'N:\BCIT_ESS_RESAMPLED\X3 Baseline Guard Duty';
% theTitle = 'X3 Baseline Guard Duty';

% ess2Dir = 'N:\BCIT_ESS\X4 Advanced Guard Duty';
% outDir = 'N:\BCIT_ESS_RESAMPLED\X4 Advanced Guard Duty';
% theTitle = 'X4 Advanced Guard Duty';


%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% See whether the additional information directory exists
additionalDir = [outDir filesep 'additional_data'];
if ~exist(additionalDir, 'dir')
    mkdir(additionalDir);
end

%% Now copy the reports
fprintf('%d files to be copied\n', length(filenames));
for k = 1:length(filenames)
    [pathstr, name, ext] = fileparts(filenames{k});
    reportFile = [pathstr filesep 'report_' name '.pdf'];
    if ~exist(reportFile, 'file')
        warning([reportFile ' does not exist']);
        continue;
    end
    outFile = [additionalDir filesep 'report_' name '.pdf'];
    copyfile(reportFile, outFile);
end