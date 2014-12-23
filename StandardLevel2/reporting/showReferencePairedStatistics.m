    function [ ] = showReferencePairedStatistics(referenceStats1, referenceStats2)
    %% Extract the fields
    collectionTitle1 = referenceStats1.collectionTitle;
    statisticsTitles1 = referenceStats1.statisticsTitles;
    statistics1 = referenceStats1.statistics;
    collectionTitle2 = referenceStats2.collectionTitle;
    statistics2 = referenceStats2.statistics;
    divideColor = [0.85, 0.85, 0.85];
    
    %% Plot median overall channel deviation
    minDev = min(min(statistics1(:, 2)), min(statistics2(:, 2)));
    maxDev = max(max(statistics1(:, 2)), max(statistics2(:, 2)));
    baseTitle = 'Median overall channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 2), statistics2(:, 2), 'ok')
    plot(median(statistics1(:, 2)),median(statistics2(:, 2)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(statistics1(:, 2)))  ...
         ' 2: ' num2str(median(statistics2(:, 2))) ']']});
    xlabel('1: Median dataset channel deviation');
    ylabel('2: Median dataset channel deviation');
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

    %% Plot robust SD of overall channel deviation
    minSDR = min(min(statistics1(:, 4)), min(statistics2(:, 4)));
    maxSDR = max(max(statistics1(:, 4)), max(statistics2(:, 4)));
    baseTitle = 'SDR overall channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 4), statistics2(:, 4), 'ok')
    plot(median(statistics1(:, 4)),median(statistics2(:, 4)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    xlabel('1: Overall dataset SDR collection');
    ylabel('2: Overall dataset SDR collection');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(statistics1(:, 4)))  ...
         ' 2: ' num2str(median(statistics2(:, 4))) ']']});
    legend('Median SDR dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

   %% Plot ratios (ref/org) of overall median deviation collection 1 versus collection 2
    medRatio1 = statistics1(:, 2)./statistics1(:, 1);
    medRatio2 = statistics2(:, 2)./statistics2(:, 1);
    maxRatio = max(max(medRatio1), max(medRatio2));
    minRatio = min(min(medRatio1), min(medRatio2));
    baseTitle = 'Ratio of ref/orig overall channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(medRatio1, medRatio2, 'ok')
    plot(median(medRatio1), median(medRatio2), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minRatio, maxRatio], 'XLimMode', 'manual', ...
        'YLim', [minRatio, maxRatio], 'YLimMode', 'manual');
    line([minRatio; maxRatio], [minRatio; maxRatio], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: Deviation ratio');
    ylabel('2: Deviation ratio');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(medRatio1))  ...
         ' 2: ' num2str(median(medRatio2)) ']']});
    legend('Median dataset ratio', 'Median of medians', 'Location', 'NorthWest')
    hold off

   %% Plot ratios (ref/org) of overall robust SD collection 1 versus collection 2
    sdrRatio1 = statistics1(:, 4)./statistics1(:, 3);
    sdrRatio2 = statistics2(:, 4)./statistics2(:, 3);
    maxRatio = max(max(sdrRatio1), max(sdrRatio2));
    minRatio = min(min(sdrRatio1), min(sdrRatio2));    
    baseTitle = 'Ratio of ref/orig overall SDR channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(sdrRatio1, sdrRatio1, 'ok')
    plot(median(sdrRatio1), median(sdrRatio2), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minRatio, maxRatio], 'XLimMode', 'manual', ...
        'YLim', [minRatio, maxRatio], 'YLimMode', 'manual');
    line([minRatio; maxRatio], [minRatio; maxRatio], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: SDR ratio');
    ylabel('2: SDR ratio');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(sdrRatio1))  ...
         ' 2: ' num2str(median(sdrRatio2)) ']']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

    %% Plot medians of window channel deviation
    minDev = min(min(statistics1(:, 6)), min(statistics2(:, 6)));
    maxDev = max(max(statistics1(:, 6)), max(statistics2(:, 6)));
    baseTitle = 'Median window channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 6), statistics2(:, 6), 'ok')
    plot(median(statistics1(:, 6)),median(statistics2(:, 6)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: Median window channel deviation');
    ylabel('2: Median window channel deviation');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(statistics1(:, 6)))  ...
         ' 2: ' num2str(median(statistics2(:, 6))) ']']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest');
    hold off
    
    %% Plot robust SD of median window channel deviations
    minSDR = min(min(statistics1(:, 8)), min(statistics2(:, 8)));
    maxSDR = max(max(statistics1(:, 8)), max(statistics2(:, 8)));
    baseTitle = 'SDR window channel deviation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 8), statistics2(:, 8), 'ok')
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');  
    plot(median(statistics1(:, 8)),median(statistics2(:, 8)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: SDR window channel deviation');
    ylabel('2: SDR window channel deviation');
    title({baseTitle; ...
        ['[Median SDRs 1 :' num2str(median(statistics1(:, 8)))  ...
         ' 2: ' num2str(median(statistics2(:, 8))) ']']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off

   %% Plot ratios (ref/org) of median vs robust SD of window channel deviations
    medRatio1 = statistics1(:, 6)./statistics1(:, 5);
    medRatio2 = statistics2(:, 6)./statistics2(:, 5);
    maxRatio = max(max(medRatio1), max(medRatio2));
    minRatio = min(min(medRatio1), min(medRatio2));   
    baseTitle = 'Ratio of ref/orig median window channel deviations';
    figure ('Name', baseTitle);
    hold on
    plot(medRatio1, medRatio2, 'ok')
    plot(median(medRatio1), median(medRatio2), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    set(gca, 'XLim', [minRatio, maxRatio], 'XLimMode', 'manual', ...
        'YLim', [minRatio, maxRatio], 'YLimMode', 'manual');
    line([minRatio; maxRatio], [minRatio; maxRatio], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: Ratio channel window deviations');
    ylabel('2: Ratio channel window deviations');
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(medRatio1))  ...
        ' 2: ' num2str(median(medRatio2)) ']']});
    legend('Median dataset', 'Median of medians', 'Location', 'NorthWest')
    hold off   
    %% Plot before and after median max correlation
    minCorr1 = min(min(statistics1(:, 9), min(statistics1(:, 10))));
    minCorr2 = min(min(statistics2(:, 9), min(statistics2(:, 10))));
    minCorr = min(minCorr1, minCorr2);
    baseTitle = 'Median max window correlation before and after referencing';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 9), statistics1(:, 10), 'ok')
    plot(statistics2(:, 9), statistics2(:, 10), 'sb')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(median(statistics1(:, 9)), median(statistics1(:, 10)), ...
        'or', 'MarkerSize', 14, 'LineWidth', 3);
    plot(median(statistics2(:, 9)), median(statistics2(:, 10)), ...
        'sg', 'MarkerSize', 14, 'LineWidth', 3);
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel(statisticsTitles1{9});
    ylabel(statisticsTitles1{10});
    title({baseTitle; ...
        ['[Medians 1: ' num2str(median(statistics1(:, 9))) '(orig) ' ...
        num2str(median(statistics1(:, 10))) '(ref)' ...
        ' 2: ' num2str(median(statistics2(:, 9))) '(orig) ' ...
        num2str(median(statistics2(:, 10))) '(ref)]']});
    legend('1: Dataset median', '2: Dataset median', ...
           '1: Median of medians', '2: Median of medians', ...
           'Location', 'NorthWest');
    hold off

  %% Plot mean ref correlation collection 1 versus collection 2
    minCorr = min(min(statistics1(:, 10), min(statistics1(:, 12))));
    baseTitle = 'Mean max window correlation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 12), statistics2(:, 12), 'ok')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');

    plot(mean(statistics1(:, 12)), mean(statistics2(:, 12)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel('1: Average dataset window correlation');
    ylabel('2: Average dataset window correlation');
    title({baseTitle; ...
        ['1:' collectionTitle1 '  2:' collectionTitle2]; ...
        ['[Means 1 :' num2str(mean(statistics1(:, 12)))  ...
         ' 2: ' num2str(mean(statistics2(:, 12))) ']']});
     legend('Dataset window mean', 'Mean of means', 'Location', 'NorthWest')
    hold off
%% Plot before and after mean max correlation collection 1 versus 2
    minCorr1 = min(min(statistics1(:, 11), min(statistics1(:, 12))));
    minCorr2 = min(min(statistics2(:, 11), min(statistics2(:, 12))));
    minCorr = min(minCorr1, minCorr2);
    baseTitle = 'Mean max window correlation collection 1 vs 2';
    figure ('Name', baseTitle);
    hold on
    plot(statistics1(:, 11), statistics1(:, 12), 'ok')
    plot(statistics2(:, 11), statistics2(:, 12), 'sb')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(mean(statistics1(:, 11)), mean(statistics1(:, 12)), ...
        'or', 'MarkerSize', 14, 'LineWidth', 3);
    plot(mean(statistics2(:, 11)), mean(statistics2(:, 12)), ...
        'sg', 'MarkerSize', 14, 'LineWidth', 3);
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel(statisticsTitles1{11});
    ylabel(statisticsTitles1{12});
    title({baseTitle; ...
        ['1:' collectionTitle1 '  2:' collectionTitle2]; ...
        ['[Means 1 :' num2str(mean(statistics1(:, 11))) '(orig) ' ...
        num2str(mean(statistics1(:, 12))) '(ref)'  ...
         ' 2: ' num2str(mean(statistics2(:, 11))) '(orig) ' ...
        num2str(mean(statistics2(:, 12))) '(ref)]']});
    legend('1: Dataset window means', '2: Dataset window means', ...
           '1: Mean of means', '2: Mean of means', ...
           'Location', 'NorthWest');
    hold off
end