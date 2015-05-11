function [referenceLocations, evaluationChannels, legendString] = ...
        getReportChannelInformation(channelLocations, ...
                                    evaluationChannels, noisyChannels)
    % Extracts channel locations with bad channels labeled, info and 
    % reference channel list from report
    badNaNSymbol = 'n';
    badNoDataSymbol = 'z';
    badLowSNRSymbol = 's';
    badDropOutSymbol = 'd';
    badCorrelationSymbol = 'c';
    badAmplitudeSymbol = '+';
    badNoiseSymbol = 'x';
    badRansacSymbol = '?';
    legendString = {'NaN: n', 'NoData: z', 'LowSNR: s', 'Corr: c', ...
                    'Amp: +', 'Noise: x', 'Ran: ?'};
    chanlocs = channelLocations;
    if ~isempty(noisyChannels.badChannelsFromNaNs)
        noisy = noisyChannels.badChannelsFromNaNs(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badNaNSymbol];
        end
    end
    
    if ~isempty(noisyChannels.badChannelsFromNoData)
        noisy = noisyChannels.badChannelsFromNoData(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badNoDataSymbol];
        end
    end
    
    if ~isempty(noisyChannels.badChannelsFromLowSNR)
        noisy = noisyChannels.badChannelsFromLowSNR(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badLowSNRSymbol];
        end
    end
    
    if ~isempty(noisyChannels.badChannelsFromDropOuts)
        noisy = noisyChannels.badChannelsFromDropOuts(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badDropOutSymbol];
        end
    end
    
    if ~isempty(noisyChannels.badChannelsFromCorrelation)
        noisy = noisyChannels.badChannelsFromCorrelation(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badCorrelationSymbol];
        end
    end
    
    if ~isempty(noisyChannels.badChannelsFromDeviation)
        noisy = noisyChannels.badChannelsFromDeviation(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badAmplitudeSymbol];
        end
    end

    if ~isempty(noisyChannels.badChannelsFromHFNoise)
        noisy = noisyChannels.badChannelsFromHFNoise(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badNoiseSymbol];
        end
    end

    if ~isempty(noisyChannels.badChannelsFromRansac)
        noisy = noisyChannels.badChannelsFromRansac(:)';
        for j = noisy
            chanlocs(j).labels = [chanlocs(j).labels badRansacSymbol];
        end
    end

    good_chans = setdiff(evaluationChannels, noisyChannels.all);
    for j = good_chans
        chanlocs(j).labels = ' ';
    end
    referenceLocations = chanlocs(evaluationChannels);
end


