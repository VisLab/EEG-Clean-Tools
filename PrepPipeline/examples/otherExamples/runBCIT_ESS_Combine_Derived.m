%% Example using ESS to combine to level derived BCIT folders 

%% Define the folders to be combined and the output file
% folder1 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\Experiment XB Baseline DrivingFirst';
% folder2 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\Experiment XB Baseline DrivingSecond';
% combined = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\Experiment XB Baseline Driving';

% folder1 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP ExpertiseMiddle';
% folder2 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP ExpertiseLast';
% combined = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP ExpertiseCombo';

folder1 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP ExpertiseFirst';
folder2 = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP ExpertiseCombo';
combined = 'O:\ARL_Data\BCIT_ESS_256Hz_Infomax\X2 RSVP Expertise';

%% Run ESS combining derived studies
obj = levelDerivedStudy;
obj = obj.combinePartialRuns({folder1, folder2}, combined);
