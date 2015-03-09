%% Script illustrating how to call showChannelTrend
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
k = 3;
basename = 'vep';
thisName = sprintf('%s_%02d', basename, k);
fname = [indir filesep thisName '.set'];
EEG = pop_loadset(fname);
EEGChannels = 1:64;            % EEG channels for the dataset
displayChannels = [1, 7, 18];  % Show trends for these channels
seconds = [200, 400];          % Time interval in seconds to display
showChannelTrend(EEG, EEGChannels, displayChannels, seconds)
