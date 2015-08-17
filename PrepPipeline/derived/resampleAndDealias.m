function EEG = resampleAndDealias(EEG, varargin)
% Perform a high-pass filter and ICA on data that has been Prepped
try
    params = vargin2struct(varargin);
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.resampleAndDealias = resampling;
    %% Perform ICA on the data
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'reference')
        EEG.etc.noiseDetection.reference = ...
                   cleanupReference(EEG.etc.noiseDetection.reference);
    end
    
catch mex
    errorMessages.resampleAndDealias = ['failed resampleAndDealias: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.highPassAndICA.errors = errorMessages;
    fprintf('%d: error %s\n', k, errorMessages.highPassAndICA);
end