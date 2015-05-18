    function [ ] = showNoisyStatistics(noisyStats)
    %% Plot statistics for a dataset collection based on single noisy structure
    
    %% Extract the fields
    collectionTitle = noisyStats.collectionTitle;
    statisticsTitles = noisyStats.statisticsTitles;
    s = noisyStats.statisticsIndex;
    statistics = noisyStats.statistics;
    divideColor = [0.85, 0.85, 0.85];
    
    %% Plot median versus SDR overall channel deviation
    minDev = min(statistics(:, s.medDev));
    maxDev = max(statistics(:, s.medDev));
    minrSD = min(statistics(:, s.rSDDev));
    maxrSD = max(statistics(:, s.rSDDev));
    baseTitle = 'Median versus SDR overall channel deviation';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medDev), statistics(:, s.rSDDev), 'ok')
    xlabel(statisticsTitles{s.medDev});
    ylabel(statisticsTitles{s.rSDDev});
    title(collectionTitle)
    medDev = median(statistics(:, s.medDev));
    rSDDev = median(statistics(:, s.rSDDev));
    plot(medDev, rSDDev, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minrSD, maxrSD], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medDev) '(med dev) ' ...
        num2str(rSDDev) '(rSD dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
    
    %% Plot median versus SDR window channel deviation
    minWinDev = min(statistics(:, s.medWinDev));
    maxWinDev = max(statistics(:, s.medWinDev));
    minWinrSD = min(statistics(:, s.rSDWinDev));
    maxWinrSD = max(statistics(:, s.rSDWinDev));
    baseTitle = 'Median versus SDR window channel deviation';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medWinDev), statistics(:, s.rSDWinDev), 'ok')
    xlabel(statisticsTitles{s.medWinDev});
    ylabel(statisticsTitles{s.rSDWinDev});
    title(collectionTitle)
    medWinDev = median(statistics(:, s.medWinDev));
    rSDWinDev = median(statistics(:, s.rSDWinDev));
    plot(medWinDev, rSDWinDev, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minWinDev; maxWinDev], [minWinrSD; maxWinrSD], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minWinDev, maxWinDev], 'XLimMode', 'manual', ...
        'YLim', [minWinrSD, maxWinrSD], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medWinDev) '(med dev) ' ...
        num2str(rSDWinDev) '(rSD dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
    
%% Plot median maximum correlation versus median window channel deviation
    minWinDev = min(statistics(:, s.medWinDev));
    maxWinDev = max(statistics(:, s.medWinDev));
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Median maximum correlation versus median window channel deviation';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medCor), statistics(:, s.medWinDev), 'ok')

    xlabel(statisticsTitles{s.medCor});
    ylabel(statisticsTitles{s.medWinDev});
    medWinDev = median(statistics(:, s.medWinDev));
    medCorr = median(statistics(:, s.medCor));
    plot(medCorr, medWinDev, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinDev, maxWinDev], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medCorr) '(corr) ' ...
        num2str(medWinDev) '(med dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off

    %% Plot median maximum correlation versus window channel deviation ratio
    devRatio = statistics(:, s.rSDWinDev)./statistics(:, s.medWinDev);
    minWinRatio = min(devRatio);
    maxWinRatio = max(devRatio);
    yLabelString = 'rSDR/median window channel deviation';
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Median maximum correlation versus window channel deviation ratio';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medCor), devRatio, 'ok')
    xlabel(statisticsTitles{s.medCor});
    ylabel(yLabelString);
    medRatio = median(devRatio);
    medCorr = median(statistics(:, s.medCor));
    plot(medCorr, medRatio, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinRatio, maxWinRatio], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medCorr) '(corr) ' ...
        num2str(medRatio) '(rSD/med dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
 
%% Plot average maximum correlation versus median window channel deviation
    minWinDev = min(statistics(:, s.medWinDev));
    maxWinDev = max(statistics(:, s.medWinDev));
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Average maximum correlation versus median window channel deviation';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.aveCor), statistics(:, s.medWinDev), 'ok')

    xlabel(statisticsTitles{s.aveCor});
    ylabel(statisticsTitles{s.medWinDev});
    medWinDev = median(statistics(:, s.medWinDev));
    aveCorr = median(statistics(:, s.aveCor));
    plot(aveCorr, medWinDev, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinDev, maxWinDev], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(aveCorr) '(corr) ' ...
        num2str(medWinDev) '(med dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off

    %% Plot average maximum correlation versus window channel deviation ratio
    devRatio = statistics(:, s.rSDWinDev)./statistics(:, s.medWinDev);
    minWinRatio = min(devRatio);
    maxWinRatio = max(devRatio);
    yLabelString = 'rSDR/median window channel deviation';
    minCorr = min(statistics(:, s.aveCor));
    baseTitle = 'Average maximum correlation versus window channel deviation ratio';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.aveCor), devRatio, 'ok')
    xlabel(statisticsTitles{s.aveCor});
    ylabel(yLabelString);
    medRatio = median(devRatio);
    aveCorr = median(statistics(:, s.aveCor));
    plot(aveCorr, medRatio, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinRatio, maxWinRatio], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(aveCorr) '(corr) ' ...
        num2str(medRatio) '(rSD/med dev)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
 

    %% Plot median versus SDR overall HF noise
    minHF = min(statistics(:, s.medHF));
    maxHF = max(statistics(:, s.medHF));
    minrSD = min(statistics(:, s.rSDHF));
    maxrSD = max(statistics(:, s.rSDHF));
    baseTitle = 'Median versus SDR overall channel HF noise';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medHF), statistics(:, s.rSDHF), 'ok')
    xlabel(statisticsTitles{s.medHF});
    ylabel(statisticsTitles{s.rSDHF});
    title(collectionTitle)
    medHF = median(statistics(:, s.medHF));
    rSDHF = median(statistics(:, s.rSDHF));
    plot(medHF, rSDHF, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minHF, maxHF], 'XLimMode', 'manual', ...
        'YLim', [minrSD, maxrSD], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medHF) '(med HF) ' ...
        num2str(rSDDev) '(rSD HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
    
    %% Plot median versus SDR window channel HF noise
    minWinHF = min(statistics(:, s.medWinHF));
    maxWinHF = max(statistics(:, s.medWinHF));
    minWinrSD = min(statistics(:, s.rSDWinHF));
    maxWinrSD = max(statistics(:, s.rSDWinHF));
    baseTitle = 'Median versus SDR window channel HF noise';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medWinHF), statistics(:, s.rSDWinHF), 'ok')
    xlabel(statisticsTitles{s.medWinHF});
    ylabel(statisticsTitles{s.rSDWinHF});
    title(collectionTitle)
    medWinHF = median(statistics(:, s.medWinHF));
    rSDWinHF = median(statistics(:, s.rSDWinHF));
    plot(medWinHF, rSDWinHF, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minWinHF, maxWinHF], 'XLimMode', 'manual', ...
        'YLim', [minWinrSD, maxWinrSD], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medWinHF) '(med HF) ' ...
        num2str(rSDWinHF) '(rSD HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
    
%% Plot median maximum correlation versus median window channel HF noise
    minWinHF = min(statistics(:, s.medWinHF));
    maxWinHF = max(statistics(:, s.medWinHF));
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Median maximum correlation versus median window channel HF noise';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medCor), statistics(:, s.medWinHF), 'ok')

    xlabel(statisticsTitles{s.medCor});
    ylabel(statisticsTitles{s.medWinHF});
    medWinHF = median(statistics(:, s.medWinHF));
    medCorr = median(statistics(:, s.medCor));
    plot(medCorr, medWinHF, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinHF, maxWinHF], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medCorr) '(corr) ' ...
        num2str(medWinHF) '(med HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off

    %% Plot median maximum correlation versus window channel HF ratio
    HFRatio = statistics(:, s.rSDWinHF)./statistics(:, s.medWinHF);
    minWinRatio = min(HFRatio);
    maxWinRatio = max(HFRatio);
    yLabelString = 'rSDR/median window channel HF noise';
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Median maximum correlation versus window channel HF noise ratio';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.medCor), HFRatio, 'ok')
    xlabel(statisticsTitles{s.medCor});
    ylabel(yLabelString);
    medRatio = median(HFRatio);
    medCorr = median(statistics(:, s.medCor));
    plot(medCorr, medRatio, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinRatio, maxWinRatio], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(medCorr) '(corr) ' ...
        num2str(medRatio) '(rSD/med HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off
 
%% Plot average maximum correlation versus median window channel deviation
    minWinHF = min(statistics(:, s.medWinHF));
    maxWinHF = max(statistics(:, s.medWinHF));
    minCorr = min(statistics(:, s.medCor));
    baseTitle = 'Average maximum correlation versus median window HF noise';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.aveCor), statistics(:, s.medWinHF), 'ok')

    xlabel(statisticsTitles{s.aveCor});
    ylabel(statisticsTitles{s.medWinHF});
    medWinHF = median(statistics(:, s.medWinHF));
    aveCorr = median(statistics(:, s.aveCor));
    plot(aveCorr, medWinHF, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinHF, maxWinHF], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(aveCorr) '(corr) ' ...
        num2str(medWinHF) '(med HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off

    %% Plot average maximum correlation versus window channel HF noise ratio
    devRatio = statistics(:, s.rSDWinHF)./statistics(:, s.medWinHF);
    minWinRatio = min(devRatio);
    maxWinRatio = max(devRatio);
    yLabelString = 'rSDR/median window channel HF noise';
    minCorr = min(statistics(:, s.aveCor));
    baseTitle = 'Average maximum correlation versus window channel HF noise ratio';
    figure ('Name', baseTitle, 'Color', [1, 1, 1]);
    hold on
    plot(statistics(:, s.aveCor), devRatio, 'ok')
    xlabel(statisticsTitles{s.aveCor});
    ylabel(yLabelString);
    medRatio = median(devRatio);
    aveCorr = median(statistics(:, s.aveCor));
    plot(aveCorr, medRatio, '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minWinRatio, maxWinRatio], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(aveCorr) '(corr) ' ...
        num2str(medRatio) '(rSD/med HF)]']}, 'interpreter', 'none');
    legend('Dataset', 'Collection median', 'Location', 'NorthWest')
    box on
    hold off