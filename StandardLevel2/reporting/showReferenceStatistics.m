    function [ ] = showReferenceStatistics(referenceStats)
    %% Extract the fields
    collectionTitle = referenceStats.collectionTitle;
    statisticsTitles = referenceStats.statisticsTitles;
    statistics = referenceStats.statistics;
    divideColor = [0.85, 0.85, 0.85];
    %% Plot median overall channel deviation
    minDev = min(min(statistics(:, 1)), min(statistics(:, 2)));
    maxDev = max(max(statistics(:, 1)), max(statistics(:, 2)));
    baseTitle = 'Median overall channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 1), statistics(:, 2), 'ok')
    xlabel(statisticsTitles{1});
    ylabel(statisticsTitles{2});
    title(collectionTitle)
    plot(median(statistics(:, 1)), median(statistics(:, 2)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(statistics(:, 1))) '(orig) ' ...
        num2str(median(statistics(:, 2))) '(ref)]']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

    %% Plot robust SD of overall channel deviation
    minSDR = min(min(statistics(:, 3)), min(statistics(:, 4)));
    maxSDR = max(max(statistics(:, 3)), max(statistics(:, 4)));
    baseTitle = 'SDR overall channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 3), statistics(:, 4), 'ok')
    xlabel(statisticsTitles{3});
    ylabel(statisticsTitles{4});
    plot(median(statistics(:, 3)),median(statistics(:, 4)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(statistics(:, 3))) '(orig) ' ...
        num2str(median(statistics(:, 4))) '(ref)]']});
    legend('Median SDR dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of overall channel deviation
    medRatio = statistics(:, 2)./statistics(:, 1);
    sdrRatio = statistics(:, 4)./statistics(:, 3);
    baseTitle = 'Ratio of ref/orig overall channel deviation vs robust SD';
    figure ('Name', baseTitle);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Median ratio dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

    %% Plot medians of window channel deviation
    minDev = min(min(statistics(:, 5)), min(statistics(:, 6)));
    maxDev = max(max(statistics(:, 5)), max(statistics(:, 6)));
    baseTitle = 'Median window channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 5), statistics(:, 6), 'ok')
    plot(median(statistics(:, 5)),median(statistics(:, 6)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    xlabel(statisticsTitles{5});
    ylabel(statisticsTitles{6});
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(statistics(:, 5))) '(orig) ' ...
        num2str(median(statistics(:, 6))) '(ref)]']});
     legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off
    %% Plot robust SD of median window channel deviations
    minSDR = min(min(statistics(:, 7)), min(statistics(:, 8)));
    maxSDR = max(max(statistics(:, 7)), max(statistics(:, 8)));
    baseTitle = 'Robust SD Median window channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 7), statistics(:, 8), 'ok')

    plot(median(statistics(:, 7)),median(statistics(:, 8)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    xlabel(statisticsTitles{7});
    ylabel(statisticsTitles{8});
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(statistics(:, 7))) '(orig) ' ...
        num2str(median(statistics(:, 8))) '(ref)]']});
     legend('Median SDR dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of window channel deviations
    baseTitle = 'Ratio of ref/orig window channel deviations vs SDRs';
    figure ('Name', baseTitle);
    medRatio = statistics(:, 6)./statistics(:, 5);
    sdrRatio = statistics(:, 8)./statistics(:, 7);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Median ratio dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off
    
    %% Plot before and after median max correlation
    minCorr = min(min(statistics(:, 9), min(statistics(:, 10))));
    baseTitle = 'Median max window correlation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 9), statistics(:, 10), 'ok')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(median(statistics(:, 9)), median(statistics(:, 10)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    xlabel(statisticsTitles{9});
    ylabel(statisticsTitles{10});
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    title({collectionTitle; baseTitle; ...
        ['[Medians: ' num2str(median(statistics(:, 9))) '(orig) ' ...
        num2str(median(statistics(:, 10))) '(ref)]']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')

    hold off
    
    %% Plot before and after mean max correlation
    minCorr = min(min(statistics(:, 11), min(statistics(:, 12))));
    baseTitle = 'Mean max window correlation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, 11), statistics(:, 12), 'ok')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(mean(statistics(:, 11)), mean(statistics(:, 12)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel(statisticsTitles{11});
    ylabel(statisticsTitles{12});
    title({collectionTitle; baseTitle; ...
        ['[Means: ' num2str(mean(statistics(:, 11))) '(orig) ' ...
        num2str(mean(statistics(:, 12))) '(ref)]']});
     legend('Mean dataset', 'Mean of means', 'Location', 'NorthWest')

    hold off

    end