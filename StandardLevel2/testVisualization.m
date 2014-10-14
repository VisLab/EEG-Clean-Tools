datadir = 'N:\\ARLAnalysis\\RSVPStandardLevel2';
htmlbase = 'N:\\ARLAnalysis\\RSVPStandardLevel2Reports';
basename = 'rsvp';

%% Read in the data
k = 3;
thisFile = sprintf('%s_%02d', basename, k);
fname = [datadir filesep thisFile '.set'];
load(fname, '-mat');
noisyParameters = EEG.etc.noisyParameters;
reference = noisyParameters.reference;
%% Show the channels before and after        
showNoisyChannels(reference.noisyChannelOriginal, ...
    reference.channelLocations, reference.channelInformation, ...
    reference.referenceChannels, noisyParameters.name, 'Before referencing');
showNoisyChannels(reference.noisyChannelResults, ...
    reference.channelLocations, reference.channelInformation, ...
    reference.referenceChannels, noisyParameters.name, ' Final interpolation');

%% Checking
verticalLabel = ['Channels (out of ' ...
                  num2str(length(reference.referenceChannels)) ')'];
beforeRef = reference.noisyChannelOriginal;
afterRef = reference.noisyChannelResults;

%% Compare channels with bad noise levels before and after references
beforeNoise = sum(beforeRef.noiseLevels >= reference.highFrequencyNoiseThreshold);
afterNoise = sum(afterRef.noiseLevels >= reference.highFrequencyNoiseThreshold);
tString = ['Noise threshold ' noisyParameters.name]; 
figure('Name', tString)
hold on
timeScale = (0:length(beforeNoise)-1)*reference.correlationWindowSeconds;
plot(timeScale,beforeNoise, '+k')
plot(timeScale, afterNoise, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');

%% Compare channels with robust deviation before and after references
beforeDeviation = sum(beforeRef.channelDeviations >= reference.robustDeviationThreshold);
afterDeviation = sum(afterRef.channelDeviations >= reference.robustDeviationThreshold);
tString = ['Robust deviation ' noisyParameters.name]; 
figure('Name', tString)
hold on
timeScale = (0:length(beforeDeviation)-1)*reference.correlationWindowSeconds;
plot(timeScale,beforeDeviation, '+k')
plot(timeScale, afterDeviation, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');

%% Compare channels with max correlations before and after references
beforeCorrelation = sum(beforeRef.maximumCorrelations < reference.correlationThreshold);
afterCorrelation = sum(afterRef.maximumCorrelations < reference.correlationThreshold);
tString = ['Maximum-median correlations ' noisyParameters.name]; 
figure('Name', tString)
hold on
timeScale = (1:length(beforeCorrelation))*reference.correlationWindowSeconds;
plot(timeScale, beforeCorrelation, '+k')
plot(timeScale, afterCorrelation, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');
%% Compare channels with ransac correlations before and after references
beforeRansac = sum(beforeRef.ransacCorrelations < reference.ransacCorrelationThreshold);
afterRansac = sum(afterRef.ransacCorrelations < reference.ransacCorrelationThreshold);
tString = ['Ransac correlations ' noisyParameters.name]; 
figure('Name', tString)
hold on
timeScale = (1:length(beforeRansac))*reference.ransacWindowSeconds;
plot(timeScale, beforeRansac, '+k')
plot(timeScale, afterRansac, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');