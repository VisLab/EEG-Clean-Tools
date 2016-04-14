%% Create a bad windows structure for the data collection
%
%% Level 2 manifest file name
level2File = 'studyLevel2_description.xml';

%% Set up the directories for the BCIT ESS collection
collectionType = 'ESS';
baseDir = 'O:\ARL_Data\BCIT_ESS';
outDir = 'O:\ARL_Data\BCIT_ESS\BadWindowsBCIT';

%experiment = 'Experiment X2 Traffic Complexity';
%experiment = 'Experiment X6 Speed Control';
%experiment = 'X3 Baseline Guard Duty';
%experiment = 'X4 Advanced Guard Duty';
%experiment = 'X1 Baseline RSVP';
%experiment = 'Experiment XC Calibration Driving';
%experiment = 'Experiment XB Baseline Driving';
experiment = 'X2 RSVP Expertise';
level2Path = [baseDir filesep experiment filesep level2File];

%% Open the level 2 file for the experiment
obj = level2Study('level2XmlFilePath', level2Path);

%% Get the file names
[fileNames, ~, ~, sessionNumbers] = obj.getFilename();


%% Load the data
numberSets = length(fileNames);
badWindows(numberSets) = struct('fileName', [], 'experiment', [], ...
            'session', [], 'evaluationChannels', [], ...
            'correlation', [], 'deviation', [], 'highFrequency', []);
base = struct('windowValues', [], 'windowSeconds', [], 'threshold', []);
for k = 1:length(fileNames)
       [myPath, myName, myExt] = fileparts(fileNames{k});
       fprintf('%d:%s\n', k, fileNames{k});
       badWindows(k).fileName = [myName myExt];
       badWindows(k).experiment = experiment;
       badWindows(k).session = sessionNumbers{k};
       load(fileNames{k}, '-mat');
       noisyStats = EEG.etc.noiseDetection.reference.noisyStatistics;
       badWindows(k).evaluationChannels = noisyStats.evaluationChannels;
       c = base;
       [c.windowValues, c.windowSeconds, c.threshold] = ...
                              getBadWindows(noisyStats, 'correlation');
       badWindows(k).correlation = c;
       c = base;
       [c.windowValues, c.windowSeconds, c.threshold] = ...
                              getBadWindows(noisyStats, 'deviation');
       badWindows(k).deviation = c;
       c = base;
       [c.windowValues, c.windowSeconds, c.threshold] = ...
                              getBadWindows(noisyStats, 'highfrequency');
       badWindows(k).highFrequency = c;
end

%% Save the values
outfile = [outDir filesep experiment 'badWindows.mat'];
save(outfile, 'badWindows', '-v7.3');
