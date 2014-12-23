    function [statistics, statisticsTitles] = extractReferenceStatistics(EEG)
    
    statisticsTitles = { ...
        'Median channel deviation original', ...
        'Median channel deviation referenced', ...
        'Robust SD channel deviation original', ...
        'Robust SD channel deviation, referenced', ...
        'Median window channel deviation original', ...
        'Median window channel deviation referenced', ...
        'Robust SD window channel deviation original', ...
        'Robust SD window channel deviation, referenced', ...
        'Median window correlation original', ...
        'Median window correlation referenced', ...
        'Average window correlation original', ...
        'Average window correlation referenced'};
    if nargin < 1
        statistics = [];
        return;
    end
    statistics = zeros(1, length(statisticsTitles));
    reference = EEG.etc.noisyParameters.reference;
    original = reference.noisyOutOriginal;
    referenced = reference.noisyOut;

    %% Deviations
    referenceChannels = reference.referenceChannels;
    statistics(1) = original.channelDeviationMedian;
    statistics(2) = referenced.channelDeviationMedian;
    statistics(3) = original.channelDeviationSD;
    statistics(4) = referenced.channelDeviationSD;
    beforeDeviationLevels = original.channelDeviations(referenceChannels, :);
    afterDeviationLevels = referenced.channelDeviations(referenceChannels, :);
    statistics(5) = median(beforeDeviationLevels(:));
    statistics(6) = median(afterDeviationLevels(:));
    statistics(7) = mad(beforeDeviationLevels(:), 1)*1.4826;
    statistics(8) = mad(afterDeviationLevels(:), 1)*1.4826;
    %% Correlations
    beforeCorrelation = original.maximumCorrelations(referenceChannels, :);
    afterCorrelation = referenced.maximumCorrelations(referenceChannels, :);
    statistics(9) = median(beforeCorrelation(:));
    statistics(10) = median(afterCorrelation(:));
    statistics(11) = mean(beforeCorrelation(:));
    statistics(12) = mean(afterCorrelation(:));
end