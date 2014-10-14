%%
params = struct('referenceChannels', 1:64, 'rereferenceChannels', 1:70);

refOut = findNoisyChannels(EEG, params);