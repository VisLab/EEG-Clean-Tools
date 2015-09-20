function EEG = performICA(EEG, varargin)
% Perform a ICA on data that has been Prepped
try
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
        EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1, ...
            'chanind', referenceChannels, 'pca', pcaDim);
        EEG.etc.performICA.ICA = ...
            ['extended infomax with pca Dim ' num2str(pcaDim)];
        EEG.etc.noiseDetection.reference = ...
            cleanupReference(EEG.etc.noiseDetection.reference);
    else
        throw (MException('performICA:NoPREP', ...
            'Must have performed the PREP pipeline to use this version'));
    end
catch mex
    errorMessages.performICA = ['failed performICA: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.performICA.errors = errorMessages;
    fprintf(2, '%s\n', errorMessages.performICA);
end