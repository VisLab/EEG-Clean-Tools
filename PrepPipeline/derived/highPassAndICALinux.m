function EEG = highPassAndICA(EEG, varargin)
% Perform a high-pass filter and ICA on data that has been Prepped
try
    params = vargin2struct(varargin);
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'detrend') && ...
            ~isfield(params, 'detrendChannels')
        params.detrendChannels = EEG.etc.noiseDetection.detrend.detrendChannels;
    end
    [EEG, detrend]  = removeTrend(EEG, params);
    EEG.etc.highPassAndICA.detrend = detrend;
    
    %% Perform ICA on the data
    if isfield(EEG.etc, 'noiseDetection') && ...
            isfield(EEG.etc.noiseDetection, 'reference')
        referenceChannels = ...
            EEG.etc.noiseDetection.reference.referenceChannels;
        interpolatedChannels = ...
            EEG.etc.noiseDetection.reference.interpolatedChannels.all;
        channelsLeft = setdiff(referenceChannels, interpolatedChannels);
        pcaDim = length(channelsLeft) - 1;
        fprintf('%s: pcaDim = %d\n', EEG.setname, pcaDim);
        EEG = pop_runica(EEG, 'icatype', 'cudaica', 'extended', 1, ...
            'chanind', referenceChannels, 'pca', pcaDim);
        EEG.etc.highPassAndICA.ICA = ...
            ['extended infomax with pca Dim ' num2str(pcaDim)];
        EEG.etc.noiseDetection.reference = ...
                   cleanupReference(EEG.etc.noiseDetection.reference);
%     else
%         EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);
%         EEG.etc.highPassAndICA.ICA = 'runica extended infomax';
    end
    
catch mex
    errorMessages.highPassAndICA = ['failed highPassAndICA: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.highPassAndICA.errors = errorMessages;
    fprintf(2, '%s\n', errorMessages.highPassAndICA);
end