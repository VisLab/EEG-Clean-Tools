function EEG = resampleAndFilterLarg(EEG, varargin)
% Resample and filter for the LARG pipeline
% remove extra fields from EEG.etc.noiseDetection

try
    params = vargin2struct(varargin);
    maxSamplingRate = params.maxSamplingRate;
    highPassFrequency = params.highPassFrequency;            
    if EEG.srate > maxSamplingRate
            EEG = pop_resample(EEG, maxSamplingRate);
    end;
        
    EEG = pop_eegfiltnew(EEG, [], highPassFrequency, 1690, true, [], 0); 
    EEG.etc.resampleAndFilterLarg.maxSamplingRate = maxSamplingRate;
    EEG.etc.resampleAndFilterLarg.highPassFrequency = highPassFrequency;
    
    %% Clean up the reference as appropriate
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'reference')
        EEG.etc.noiseDetection.reference = ...
                   cleanupReference(EEG.etc.noiseDetection.reference);
    end
    
catch mex
    errorMessages.resampleAndFilterLarg = ['failed resampleAndFilterLarg: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.resampleAndFilterLarg.errors = errorMessages;
    fprintf('%s: error %s\n', EEG.setname, errorMessages.resampleAndFilterLarg);
end  
