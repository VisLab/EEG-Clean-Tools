function [referenceLocations, evaluationChannels, legendString] = ...
        getReportChannelInformation(channelLocations, results)
    % Extracts channel locations with bad channels labeled, info and 
    % reference channel list from report
    badNaNSymbol = 'n';
    badNoDataSymbol = 'z';
    badDropOutSymbol = 'd';
    badCorrelationSymbol = 'c';
    badAmplitudeSymbol = '+';
    badNoiseSymbol = 'x';
    badRansacSymbol = '?';
    legendString = {'NaN: n', 'NoData: z', 'Corr: c', ...
                    'Amp: +', 'Noise: x', 'Ran: ?'};
    chanlocs = channelLocations;
    evaluationChannels = results.evaluationChannels;
    noisyChannels = getFieldIfExists(results, 'noisyChannels');
    % Set the bad channel labels

    if isfield(noisyChannels, 'badChannelsFromNaNs')
        for j = noisyChannels.badChannelsFromNaNs
            chanlocs(j).labels = [chanlocs(j).labels badNaNSymbol];
        end
    end
    if isfield(noisyChannels, 'badChannelsFromNoData')
        for j = noisyChannels.badChannelsFromNoData
            chanlocs(j).labels = [chanlocs(j).labels badNoDataSymbol];
        end
    end
    if isfield(noisyChannels, 'badChannelsFromDropOuts')
        for j = noisyChannels.badChannelsFromDropOuts
            chanlocs(j).labels = [chanlocs(j).labels badDropOutSymbol];
        end
    end
    for j = noisyChannels.badChannelsFromCorrelation
        chanlocs(j).labels = [chanlocs(j).labels badCorrelationSymbol];
    end
    for j = noisyChannels.badChannelsFromDeviation
        chanlocs(j).labels = [chanlocs(j).labels badAmplitudeSymbol];
    end

    for j = noisyChannels.badChannelsFromHFNoise
        chanlocs(j).labels = [chanlocs(j).labels badNoiseSymbol];
    end

    for j = noisyChannels.badChannelsFromRansac
        chanlocs(j).labels = [chanlocs(j).labels badRansacSymbol];
    end

    good_chans = setdiff(evaluationChannels, (noisyChannels.all)');
    for j = good_chans
        chanlocs(j).labels = ' ';
    end
    referenceLocations = chanlocs(evaluationChannels);
end


