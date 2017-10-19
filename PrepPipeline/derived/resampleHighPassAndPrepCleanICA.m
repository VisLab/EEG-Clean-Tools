function EEG = resampleHighPassAndPrepCleanICA(EEG, varargin)
% Perform a high-pass filter and ICA on data that has been Prepped and excised
% 
% Parameters:
%    EEG   EEGLAB EEG structure
%    varargin    name value pairs
%         resampleOff  -  false
%         resampleFrequency - downsampling frequency
%         lowPassFrequency  - frequency to resample
%         detrendChannels
%         detrendCutoff
%         icatype           -  runica or other supported by pop_runica
%         extended          -  true or false
%         fractionBad       - max % of channels EEG bad allowed in a window
%
% The ICA is performed on data after throwing out frames that are in
% windows with more fractionBad of the EEG channels that are bad by
% PREP deviation, high frequency and correlation criteria
%
try
    %% Convert name-value pair parameters to structure
    if ~isfield(EEG.etc, 'noiseDetection') || ...
       ~isfield(EEG.etc.noiseDetection, 'reference')
       error('resampleHighPassAndPrepCleanICA:DataNotPrepped', ...
             'Cannot run without referencing by Prep');
    end
  
    params = vargin2struct(varargin);
    [EEG, resampling] = resampleEEG(EEG, params);
    EEG.etc.resampleHighPassAndPrepCleanICA.resampling = resampling;
    %% Perform HP on the data
    if isfield(EEG.etc.noiseDetection, 'detrend') && ...
            ~isfield(params, 'detrendChannels')
        params.detrendChannels = EEG.etc.noiseDetection.detrend.detrendChannels;
    end
    [EEG, detrend]  = removeTrend(EEG, params);
    EEG.etc.resampleHighPassAndPrepCleanICA.detrend = detrend;
    
    %% Temporarily excise the frames that have a lot of bad channels 
    if ~isfield(params, 'fractionBad')
        fractionBad = 0.25;
    else
        fractionBad = params.fractionBad;
    end
    evaluationChannels = EEG.etc.noiseDetection.reference.evaluationChannels;
    numberEEGChans = length(evaluationChannels);
    maxBadChannels = round(numberEEGChans*fractionBad);
    types = {'deviation', 'correlation', 'highfrequency'};
    noisyStatistics = EEG.etc.noiseDetection.reference.noisyStatistics;
    badFrameCount = getBadFrames(noisyStatistics, types, ...
                         evaluationChannels, EEG.srate, size(EEG.data, 2));
    badFrames = badFrameCount >= maxBadChannels;
    
    originalData = EEG.data;
    originalTimes = EEG.times;
    EEG.data = EEG.data(:, ~badFrames);
    EEG.pnts = size(EEG.data, 2);
    EEG.times = EEG.times(~badFrames);
    
    %% Perform ICA on the data
    icatype = 'runica';
    if isfield(params, 'icatype')
        icatype = params.icatype;
    end
    extended = 1;
    if isfield(params, 'extended')
        extended = params.extended;
    end
    
    evaluationChannels = ...
        EEG.etc.noiseDetection.reference.evaluationChannels;
    interpolatedChannels = ...
        EEG.etc.noiseDetection.reference.interpolatedChannels.all;
    channelsLeft = setdiff(evaluationChannels, interpolatedChannels);
    pcaDim = length(channelsLeft) - 1;
    fprintf('%s: pcaDim = %d\n', EEG.setname, pcaDim);
    EEG = pop_runica(EEG, 'icatype', icatype, 'extended', extended, ...
        'chanind', evaluationChannels, 'pca', pcaDim);
    EEG.icaact = EEG.icaweights*EEG.icasphere*originalData(evaluationChannels, :);
    EEG.etc.resampleHighPassAndPrepCleanICA.ICA = ...
        ['infomax with pca Dim ' num2str(pcaDim)];
    EEG.etc.resampleHighPassAndPrepCleanICA.fractionBad = fractionBad;
    EEG.etc.resampleHighPassAndPrepCleanICA.badFrames = badFrames;
    
catch mex
    errorMessages.resampleHighPassAndPrepCleanICA = ...
        ['failed resampleHighPassAndPrepCleanICA: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.resampleHighPassAndPrepCleanICA.errors = errorMessages;
    fprintf(2, '%s\n', errorMessages.resampleHighPassAndPrepCleanICA);
end

%% Restore the original EEG data
    EEG.data = originalData;
    EEG.pnts = size(EEG.data, 2);
    EEG.times = originalTimes;