%% Load the data
load('EEG.mat');
signal = double(EEG.data(:,1:1000));
load('EEGEpoch.mat');
load('TimeScale.mat');
epochedSignal = double(EEGEpoch.data(:,:,1));
%% Continuous Data (bad channels)
g = struct('srate', EEG.srate, 'channels', [1,10,32], ...
           'titleString', 'Continuous data, 3 bad channels');
plotStackedSignals(signal, g);

%% Continuous Data (clipping off)
g = struct('srate', EEG.srate, 'channels', [1,10,32], ...
           'titleString', 'Continuous data, 3 bad channels, clipping off');
plotStackedSignals(signal, g);

%% Continuous Data (bad channels with opposite colors)
g = struct('srate', EEG.srate, 'channels', [1,10,32], ...
           'colors', [1, 0, 0; 0.7, 0.7, 0.7], ...
           'titleString', 'Continuous data, 3 bad channels, colors reversed');
plotStackedSignals(signal, g);

%% Epoched data (with time scale)
g = struct('srate', EEGEpoch.srate, 'channels', [1,10,32], ...
           'timeScale', timeScale, ...
           'titleString', 'Epoched data with 3 bad channels and time scale');
plotStackedSignals(epochedSignal, g);
