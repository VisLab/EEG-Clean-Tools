function EEG = resampleAndDealias(EEG, varargin)
% Resample and dealias using a low pass filter close to Nyquist. Also
% remove extra fields from EEG.etc.noiseDetection
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