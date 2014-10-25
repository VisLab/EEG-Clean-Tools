function showBadFrames(reference, name)
% Display number of bad channels before and after referencing by frame
%% Setting basic labels
verticalLabel = ['Channels (out of ' ...
                  num2str(length(reference.referenceChannels)) ')'];
beforeRef = reference.noisyOutOriginal;
afterRef = reference.noisyOut;

%% Compare channels with bad noise levels before and after references
beforeNoise = sum(beforeRef.noiseLevels >= afterRef.highFrequencyNoiseThreshold);
afterNoise = sum(afterRef.noiseLevels >= afterRef.highFrequencyNoiseThreshold);
tString = ['Noise threshold ' name]; 
figure('Name', tString)
hold on
timeScale = (0:length(beforeNoise)-1)*afterRef.correlationWindowSeconds;
plot(timeScale, beforeNoise, '+k')
plot(timeScale, afterNoise, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');

%% Compare channels with robust deviation before and after references
beforeDeviation = sum(beforeRef.channelDeviations >= afterRef.robustDeviationThreshold);
afterDeviation = sum(afterRef.channelDeviations >= afterRef.robustDeviationThreshold);
tString = ['Robust deviation ' name]; 
figure('Name', tString)
hold on
timeScale = (0:length(beforeDeviation)-1)*afterRef.correlationWindowSeconds;
plot(timeScale, beforeDeviation, '+k')
plot(timeScale, afterDeviation, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');

%% Compare channels with max correlations before and after references
beforeCorrelation = sum(beforeRef.maximumCorrelations < afterRef.correlationThreshold);
afterCorrelation = sum(afterRef.maximumCorrelations < afterRef.correlationThreshold);
tString = ['Maximum-median correlations ' name]; 
figure('Name', tString)
hold on
timeScale = (1:length(beforeCorrelation))*afterRef.correlationWindowSeconds;
plot(timeScale, beforeCorrelation, '+k')
plot(timeScale, afterCorrelation, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');
%% Compare channels with ransac correlations before and after references
beforeRansac = sum(beforeRef.ransacCorrelations < afterRef.ransacCorrelationThreshold);
afterRansac = sum(afterRef.ransacCorrelations < afterRef.ransacCorrelationThreshold);
tString = ['Ransac correlations ' name]; 
figure('Name', tString)
hold on
timeScale = (1:length(beforeRansac))*afterRef.ransacWindowSeconds;
plot(timeScale, beforeRansac, '+k')
plot(timeScale, afterRansac, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend('Before referencing', 'After referencing', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');