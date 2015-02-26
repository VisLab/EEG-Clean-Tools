function [nanChannels, noSignalChannels] = ...
                        findUnusableChannels(signal, evaluationChannels) 
%% Detect channels that are constant for large periods or have NaNs
nanChannels = sum(isnan(signal.data(evaluationChannels, :)), 2) > 0;
noSignalChannels = mad(signal.data(evaluationChannels, :), 1, 2) < 10e-10 | ...
    std(signal.data(evaluationChannels, :), 1, 2) < 10e-10;

%% Now convert to channel numbers
nanChannels = evaluationChannels(nanChannels);
noSignalChannels = evaluationChannels(noSignalChannels);