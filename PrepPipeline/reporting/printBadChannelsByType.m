function [] = printBadChannelsByType(fid, noisyStats, channelLabels, perRow, indent)
%% NaN criteria
    if isfield(noisyStats, 'badChannelsFromNaNs')   % temporary
        badList = getLabeledList(noisyStats.badChannelsFromNaNs, ...
            channelLabels(noisyStats.badChannelsFromNaNs), perRow, indent);
        fprintf(fid, '\nBad because of NaN:\n%s', badList);
    end
    %% All constant criteria
    if isfield(noisyStats, 'badChannelsFromNoData')   % temporary      
        badList = getLabeledList(noisyStats.badChannelsFromNoData, ...
            channelLabels(noisyStats.badChannelsFromNoData), ...
            perRow, indent);
        fprintf(fid, '\nBad because data is constant:\n%s', badList);
    end
    
    %% Low SNR (low correlation, high HF in original signal
    if isfield(noisyStats, 'badChannelsFromLowSNR')   % temporary      
        badList = getLabeledList(noisyStats.badChannelsFromLowSNR, ...
            channelLabels(noisyStats.badChannelsFromLowSNR), ...
            perRow, indent);
        fprintf(fid, '\nBad because of low SNR:\n%s', badList);
    end
    %% Dropout criteria
    if isfield(noisyStats, 'badChannelsFromDropOuts')   % temporary    
        badList = getLabeledList(noisyStats.badChannelsFromDropOuts, ...
            channelLabels(noisyStats.badChannelsFromDropOuts), ...
            perRow, indent);
        fprintf(fid, '\nBad because of drop outs:\n%s', badList);       
    end
    %% Maximum correlation criterion
    badList = getLabeledList(noisyStats.badChannelsFromCorrelation, ...
        channelLabels(noisyStats.badChannelsFromCorrelation), ...
        perRow, indent);
    fprintf(fid, '\nBad because of poor max correlation:\n%s', badList);

    %% Large deviation criterion
    badList = getLabeledList(noisyStats.badChannelsFromDeviation, ...
        channelLabels(noisyStats.badChannelsFromDeviation), perRow, indent);
    fprintf(fid, '\nBad because of large deviation:\n%s', badList);
    
    %% HF SNR ratio criterion
    badList = getLabeledList(noisyStats.badChannelsFromHFNoise, ...
        channelLabels(noisyStats.badChannelsFromHFNoise), perRow, indent);
    fprintf(fid, '\nBad because of HF noise:\n%s', badList);
      
    %% Ransac criteria
    badList = getLabeledList(noisyStats.badChannelsFromRansac, ...
        channelLabels(noisyStats.badChannelsFromRansac),perRow, indent);
    fprintf(fid, '\nBad because of poor Ransac predictability :\n%s', badList);
  