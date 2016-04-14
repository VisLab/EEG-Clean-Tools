function EEG = highPassAndICA(EEG, varargin)
% Perform a high-pass filter and ICA on data that has been Prepped
%
% Parameters
%    EEG   EEGLAB EEG structure
%    varargin    name value pairs
%         detrendChannels
%         detrendCutoff
%         icatype
%         extended
try
    %% Convert name-value pair parameters to structure
    params = vargin2struct(varargin);
  
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'detrend') && ...
            ~isfield(params, 'detrendChannels')
        params.detrendChannels = EEG.etc.noiseDetection.detrend.detrendChannels;
    end
    [EEG, detrend]  = removeTrend(EEG, params);
    EEG.etc.highPassAndICA.detrend = detrend;
    
    %% Perform ICA on the data
    icatype = 'runica';
    if isfield(params, 'icatype')
        icatype = params.icatype;
    end
    extended = 1;
    if isfield(params, 'extended')
        extended = params.extended;
    end
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'reference')
        referenceChannels = ...
            EEG.etc.noiseDetection.reference.referenceChannels;
        interpolatedChannels = ...
            EEG.etc.noiseDetection.reference.interpolatedChannels.all;
        channelsLeft = setdiff(referenceChannels, interpolatedChannels);
        pcaDim = length(channelsLeft) - 1;
        fprintf('%s: pcaDim = %d\n', EEG.setname, pcaDim);
        EEG = pop_runica(EEG, 'icatype', icatype, 'extended', extended, ...
            'chanind', referenceChannels, 'pca', pcaDim);
        EEG.etc.highPassAndICA.ICA = ...
            ['extended infomax with pca Dim ' num2str(pcaDim)];
        EEG.etc.noiseDetection.reference = ...
                   cleanupReference(EEG.etc.noiseDetection.reference);
    else
        EEG = pop_runica(EEG, 'icatype', icatype, 'extended', extended);
        EEG.etc.highPassAndICA.ICA = [icatype '_extended_' extended];
    end
    
catch mex
    errorMessages.highPassAndICA = ['failed highPassAndICA: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.highPassAndICA.errors = errorMessages;
    fprintf(2, '%s\n', errorMessages.highPassAndICA);
end