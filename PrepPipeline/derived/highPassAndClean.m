function EEG = highPassAndClean(EEG, varargin)
% Perform a high-pass filter and Nima cleaning for ICA after PREP
% Parameters
%     detrendCutoff    high pass cutoff (suggest 0.5 Hz)
%     maxBadChannels   fraction of channels allowed bad (suggest 0.15)
%     signalStd        max standard deviation of signal (suggest 3)
try
%Setup the parameters and reporting for the call   
    params = vargin2struct(varargin);   
    if ~isfield(EEG.etc, 'noiseDetection')
        error('highPassAndClean:NoEtcNoiseDetectionField', ...
            'etc.noiseDetection doesn''t exist --- run PREP pipeline first');
    elseif ~isfield(params, 'maxBadChannels') || ...
            ~isfield(params, 'signalStd') || ~isfield(params, 'detrendCutoff')
        error('highPassAndClean:MissingCleaningParameters', ...
            'must specify detrendCutoff, maxBadChannels and signalStd');
    end
    hpC = struct('detrend', [], ...
                 'referenceChannels', [], 'mask', [], ...
                 'maxBadChannels', params.maxBadChannels, ...
                 'signalSTD', params.signalStd);
    params.detrendChannels = EEG.etc.noiseDetection.detrend.detrendChannels;
    [EEG, hpC.detrend]  = removeTrend(EEG, params);
    referenceChannels = EEG.etc.noiseDetection.reference.referenceChannels;
    EEGNew = EEG;
    EEGNew.data = EEGNew.data(referenceChannels, :);
    EEGNew.nbchan = length(referenceChannels);
    EEGNew.chanlocs = EEGNew.chanlocs(referenceChannels);
    [EEGCleaned, hpC.mask]= clean_test_nima(EEGNew, 0.15, 5);
    EEG.data(referenceChannels, :) = EEGCleaned.data;
    EEG.etc.highPassAndClean = hpC;
    EEG.setname = [EEG.setname  ' Robust reference, HP filtered and cleaned with Nima combo'];    
catch mex
    errorMessages.highPassAndClean = ['failed highPassAndClean: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.highPassAndClean.errors = errorMessages;
    fprintf(2, '%s\n', errorMessages.highPassAndClean);
end