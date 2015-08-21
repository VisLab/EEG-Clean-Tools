function [EEG, params] = prepPostProcess(EEG, params)
% Run the PREP post-processing
% 

%% Part II:  HP the signal for detecting bad channels
fprintf('Preliminary detrend to compute reference\n');
try
%     tic
%     [EEGNew, detrend] = removeTrend(EEG, params);
%     EEG.etc.noiseDetection.detrend = detrend;
%     % Make sure detrend defaults are available for referencing
%     defaults = getPipelineDefaults(EEG, 'detrend');
%     params = checkDefaults(detrend, params, defaults); 
%     computationTimes.detrend = toc;
catch mex
%     errorMessages.removeTrend = ...
%         ['prepPipeline failed removeTrend: ' getReport(mex)];
%     errorMessages.status = 'unprocessed';
%     EEG.etc.noiseDetection.errors = errorMessages;
%     return;
end