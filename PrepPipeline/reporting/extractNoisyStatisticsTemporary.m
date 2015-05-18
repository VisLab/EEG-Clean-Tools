function  [summaryStats, summaryNames] = extractNoisyStatistics(noisyOut)
% noisyOut is a cell array of noisy structures
    summaryNames = {'Mean max correlation'; ...
                    'Median max correlation'; ...
                    'Median channel deviation'; ...
                    'SDR channel deviation'};
                
    summaryStats = zeros(length(noisyOut), 4);
    
    for k = 1:length(noisyOut)
        devs = noisyOut{k}.channelDeviations;
        corrs = noisyOut{k}.maximumCorrelations;
        summaryStats(k, 1) = mean(corrs(:));
        summaryStats(k, 2) = median(corrs(:));
        summaryStats(k, 3) = median(devs(:));
        summaryStats(k, 4) = mad(devs(:))*1.4826;
    end