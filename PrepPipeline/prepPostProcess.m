function [EEG, postOut] = prepPostProcess(EEG, postIn)
% PREP post-processing: HP filter, remove interpolated, cleanup metadata
%
%
% 

%% %% Check the parameters
pop_editoptions('option_single', false, 'option_savetwofiles', false);

if nargin < 1 || ~isstruct(EEG)
    error('postProcess:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2 || ~exist('postIn', 'var') || isempty(postIn)
    postIn = struct();
end
if ~isstruct(postIn)
    error('postProcess:NoData', 'second argument must be a structure')
end
postOut = struct('keepFiltered', [], 'removeInterpolatedChannels', [], ...
                  'cleanupReference', []);
defaults = getPipelineDefaults(EEG, 'postProcess');

[postOut, errors] = checkDefaults(postIn, postOut, defaults);
if ~isempty(errors)
    error('postProcess:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
EEG.etc.noiseDetection.postProcess = postOut;
%% Perform filtering if requested
 try
    if postOut.keepFiltered
      fprintf('Refiltering the data in post processing\n');
      [EEG, detrend] = removeTrend(EEG, postOut);
      EEG.etc.noiseDetection.postProcess.detrend = detrend;
    end
catch mex
    errorMessages.detrend = ...
        ['postProcessing failed removeTrend: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors.postProcess = errorMessages;
    return;
 end

%% Remove interpolated channels if requested
 try
    interpolatedChannels = EEG.etc.noiseDetection.reference.interpolatedChannels.all;
    if postOut.removeInterpolatedChannels &&~isempty(interpolatedChannels)
      channels = 1:size(EEG.data, 1);
      channels = setdiff(channels, interpolatedChannels);
      EEG.data = EEG.data(channels, :);
      EEG.nbchan = length(channels);
      EEG.chanlocs = EEG.chanlocs(channels);
      EEG.etc.noiseDetection.postProcess.removeInterpolated = ...
                                            interpolatedChannels; 
    end
catch mex
    errorMessages.removeInterpolated = ...
        ['postProcessing failed to remove interpolated channels: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors.postProcess = errorMessages;
    return;
 end

 %% Cleanup if requested
 try
    if postOut.cleanupReference
       EEG = cleanupReference(EEG);
    end
catch mex
    errorMessages.cleanupReference = ...
        ['postProcessing failed to cleanup reference information: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors.postProcess = errorMessages;
    return;
end