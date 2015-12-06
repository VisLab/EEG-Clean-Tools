%% Run the statistics for a version of the NCTU
pop_editoptions('option_single', false, 'option_savetwofiles', false);
saveFile = 'dataStatistics.mat';

%% Setup the directories and titles
% ess2Dir = 'N:\BCIT_ESS\X2 RSVP Expertise';
% outDir = 'N:\BCIT_ESS\X2 RSVP Expertise';
% theTitle = 'X2 RSVP Expertise';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'N:\BCIT_ESS\X1 Baseline RSVP';
% outDir = 'N:\BCIT_ESS\X1 Baseline RSVP';
% theTitle = 'X1 Baseline RSVP';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'N:\BCIT_ESS\Experiment X2 Traffic Complexity';
% outDir = 'N:\BCIT_ESS\Experiment X2 Traffic Complexity';
% theTitle = 'Experiment X2 Traffic Complexity';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'N:\BCIT_ESS\Experiment X6 Speed Control';
% outDir = 'N:\BCIT_ESS\Experiment X6 Speed Control';
% theTitle = 'Experiment X6 Speed Control';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';
% outDir = 'N:\BCIT_ESS\X3 Baseline Guard Duty';
% theTitle = 'X3 Baseline Guard Duty';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'N:\BCIT_ESS\Experiment XC Calibration Driving';
% outDir = 'N:\BCIT_ESS\Experiment XC Calibration Driving';
% theTitle = 'Experiment XC Calibration Driving';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

% ess2Dir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
% outDir = 'O:\ARL_Data\BCIT_ESS\X2 RSVP Expertise';
% theTitle = 'X2 RSVP Expertise';
% fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

ess2Dir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';
outDir = 'O:\ARL_Data\BCIT_ESS\X1 Baseline RSVP second run';
theTitle = 'X1 Baseline RSVP';
fieldPath = {'etc', 'noiseDetection', 'reference', 'noisyStatistics'};

%% Create a level 2 study
obj2 = level2Study('level2XmlFilePath', ess2Dir);
obj2.validate();

%% Get the files out
[filenames, dataRecordingUuids, taskLabels, sessionNumbers, subjects] = ...
    getFilename(obj2);

%% Consolidate the results in a single structure for comparative analysis
collectionStats = createCollectionStatistics(theTitle, filenames, fieldPath);
%% Save the statistics in the specified file
save([outDir filesep saveFile], 'collectionStats', '-v7.3');

%% Display the reference statistics
showNoisyStatistics(collectionStats);

