%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Specify collection files, legends and colors for the comparison
statFiles = {
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Unfiltered_ReportOld\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PostInterp_Unfiltered_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_PreInterp_Unfiltered_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PostInterp_Unfiltered_Report_Test\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrep\\VEPRobust_Median_PreInterp_Unfiltered_Report_Test\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrepNew\\VEPRobust_1Hz_Unfiltered_Report\\dataStatistics.mat'; ...
    'N:\\ARLAnalysis\\VEPPrepNewTry\\VEPRobust_1Hz_Post_Median_Unfiltered_Report\\dataStatistics.mat';
    };

legendString = {'B64-Robust-Post-Old'; 'B64-Robust-Pre-Old'; ...
    'B64-Robust-Post '; 'B64-Robust-Pre'; 'B64-Robust-Median-Post'; ...
    'B64-Robust-Median-Post-Test'; 'B64-Robust-Median-Pre-Test'; ...
    'B64-Robust-Median-Post-Test'; 'B64-Robust-Median-Post-Test-Corr'; ...
    };
collectionColors =   jet(length(legendString));

%% Consolidate the collection statistics from files
[collections, collectionStats] = getCollections(statFiles);

%% Compare statistics for different collections using boxplots
showCollectionBoxplots(collectionStats, legendString, collectionColors);

%% Calculate the rank significance of all combinations of a statistic.
rankSigRatiosDev = getRankSignificance(collectionStats.refRatiosDev, legendString);
rankSigRatiosWinDev = getRankSignificance(collectionStats.refRatiosWinDev, legendString);
rankSigRatiosWinDevOrig = getRankSignificance(collectionStats.origRatiosWinDev, legendString);
rankSigRatiosHF = getRankSignificance(collectionStats.refRatiosHF, legendString);
rankSigRatiosWinHF = getRankSignificance(collectionStats.refRatiosWinHF, legendString);
rankSigCorr = getRankSignificance(collectionStats.refCorrAve, legendString);
rankSigDev = getRankSignificance(collectionStats.refDev, legendString);
rankSigWinDev = getRankSignificance(collectionStats.refWinDev, legendString);
rankSigHF = getRankSignificance(collectionStats.refHF, legendString);
rankSigWinHF = getRankSignificance(collectionStats.refWinHF, legendString);

%%
myColors = jet(length(collections));
showCollectionStatistics(collectionStats, legendString, myColors);


%% Check channels
fprintf('\nDifferences between original pre and post\n')
showBadChannelDifferences(collections{2}.noisyChannels, ...
    collections{1}.noisyChannels);

fprintf('\nDifferences between original pre and new pre\n')
showBadChannelDifferences(collections{2}.noisyChannels, ...
    collections{4}.noisyChannels);

fprintf('\nDifferences between original pre and new post\n')
showBadChannelDifferences(collections{2}.noisyChannels, ...
    collections{3}.noisyChannels);

fprintf('\nDifferences between new pre and post\n')
showBadChannelDifferences(collections{4}.noisyChannels, ...
    collections{1}.noisyChannels);
%%
fprintf('\nDifferences between Huber post and median post\n')
showBadChannelDifferences(collections{1}.noisyChannels, ...
    collections{5}.noisyChannels);

%%
fprintf('\nDifferences between original pre and median pre test\n')
showBadChannelDifferences(collections{2}.noisyChannels, ...
    collections{7}.noisyChannels);

%%
fprintf('\nDifferences between post huber and median post test\n')
showBadChannelDifferences(collections{1}.noisyChannels, ...
    collections{6}.noisyChannels);

%
fprintf('\nDifferences between original pre and new post test\n')
showBadChannelDifferences(collections{2}.noisyChannels, ...
    collections{8}.noisyChannels);

fprintf('\nDifferences between original post and new post test\n')
showBadChannelDifferences(collections{1}.noisyChannels, ...
    collections{8}.noisyChannels);

fprintf('\nDifferences between original post and new corrected post test\n')
showBadChannelDifferences(collections{1}.noisyChannels, ...
    collections{9}.noisyChannels);
%% Data correlation versus deviation
dataDev = collectionStats.refRatiosWinDev;
dataCorr = collectionStats.refCorrAve;
myColors = jet(length(dataDev));
baseTitle = 'corr versus sdr/med ratio channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(dataDev)
    plot(dataCorr{k}, dataDev{k}, 'Color', myColors(k, :), ...
        'LineStyle', 'none', 'Marker', 'o')
end
hold off
set(gca, 'FontSize', 12)
xlabel('Median min window correlation', 'FontSize', 12)
ylabel('Ratio sdr/med window deviation', 'FontSize', 12)
box on
%% Plot ratios sdr/med window channel deviations ref versus orig
plotOriginal = true;
refCorr = collectionStats.refCorrAve;
origCorr = collectionStats.origCorrAve;
refDev = collectionStats.refRatiosWinDev;
origDev = collectionStats.origRatiosWinDev;
myColors = jet(length(refDev));
baseTitle = 'Mean min corr versus sdr/med channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(refDev)
    plot(refCorr{k}, refDev{k}, 'Color', [0, 0, 0], ...
        'LineStyle', 'None', 'Marker', 'o', 'MarkerSize', 10, 'LineWidth', 2)
    plot(median(refCorr{k}), median(refDev{k}), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    plot(origCorr{k}, origDev{k}, 'Color', [0, 0, 1], ...
        'LineStyle', 'None', 'Marker', 's', 'MarkerSize', 10, 'LineWidth', 2)
    plot(median(origCorr{k}), median(origDev{k}), ...
        'xr', 'MarkerSize', 14, 'LineWidth', 3);
end
myLegend = {'Referenced', 'Median referenced', 'Original', 'Median original'};
% else
%     myLegend = {'Referenced', 'Median referenced'};
%end

ylabel('SDR/Median ratio');
xlabel('Mean min win correlation')
title(baseTitle)

legend(myLegend(:)', 'Location', 'NorthWest')

hold off
