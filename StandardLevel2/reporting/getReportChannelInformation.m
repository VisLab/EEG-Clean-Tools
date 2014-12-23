function [referenceLocations, referenceChannels, legendString] = ...
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
    referenceChannels = results.referenceChannels;
    % Set the bad channel labels

    if isfield(results, 'badChannelsFromNaNs')
        for j = results.badChannelsFromNaNs
            chanlocs(j).labels = [chanlocs(j).labels badNaNSymbol];
        end
    end
    if isfield(results, 'badChannelsFromNoData')
        for j = results.badChannelsFromNoData
            chanlocs(j).labels = [chanlocs(j).labels badNoDataSymbol];
        end
    end
    if isfield(results, 'badChannelsFromDropOuts')
        for j = results.badChannelsFromDropOuts
            chanlocs(j).labels = [chanlocs(j).labels badDropOutSymbol];
        end
    end
    for j = results.badChannelsFromCorrelation
        chanlocs(j).labels = [chanlocs(j).labels badCorrelationSymbol];
    end
    for j = results.badChannelsFromDeviation
        chanlocs(j).labels = [chanlocs(j).labels badAmplitudeSymbol];
    end

    for j = results.badChannelsFromHFNoise
        chanlocs(j).labels = [chanlocs(j).labels badNoiseSymbol];
    end

    for j = results.badChannelsFromRansac
        chanlocs(j).labels = [chanlocs(j).labels badRansacSymbol];
    end

    good_chans = setdiff(referenceChannels, (results.noisyChannels)');
    for j = good_chans
        chanlocs(j).labels = ' ';
    end
    referenceLocations = chanlocs(referenceChannels);
end


