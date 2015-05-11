    function [ ] = showReferenceStatistics(referenceStats)
    %% Indexes
    
    %% Extract the fields
    collectionTitle = referenceStats.collectionTitle;
    statisticsTitles = referenceStats.statisticsTitles;
    s = referenceStats.statisticsIndex;
    statistics = referenceStats.statistics;
    divideColor = [0.85, 0.85, 0.85];
    %% Plot median overall channel deviation
    minDev = min(min(statistics(:, s.medDevOrig)), ...
                 min(statistics(:, s.medDevRef)));
    maxDev = max(max(statistics(:, s.medDevOrig)), ...
                 max(statistics(:, s.medDevRef)));
    baseTitle = 'Median overall channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.medDevOrig), statistics(:, s.medDevRef), 'ok')
    xlabel(statisticsTitles{s.medDevOrig});
    ylabel(statisticsTitles{2});
    title(collectionTitle)
    plot(median(statistics(:, s.medDevOrig)), ...
         median(statistics(:, s.medDevRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(median(statistics(:, s.medDevOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.medDevRef))) '(ref)]']});
    legend('Dataset median', 'Median of dataset medians', 'Location', 'NorthWest')
    hold off

    %% Plot robust SD of overall channel deviation
    minSDR = min(min(statistics(:, s.rSDDevOrig)), ...
                 min(statistics(:, s.rSDDevRef)));
    maxSDR = max(max(statistics(:, s.rSDDevOrig)), ...
                 max(statistics(:, s.rSDDevRef)));
    baseTitle = 'SDR overall channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.rSDDevOrig), statistics(:, s.rSDDevRef), 'ok')
    xlabel(statisticsTitles{s.rSDDevOrig});
    ylabel(statisticsTitles{4});
    plot(median(statistics(:, s.rSDDevOrig)),median(statistics(:, s.rSDDevRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset SDRs: ' num2str(median(statistics(:, s.rSDDevOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.rSDDevRef))) '(ref)]']});
    legend('Dataset SDR', 'Median of dataset SDRs', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of overall channel deviation
    medRatio = statistics(:, s.medDevRef)./statistics(:, s.medDevOrig);
    sdrRatio = statistics(:, s.rSDDevRef)./statistics(:, s.rSDDevOrig);
    baseTitle = 'Ratio of ref/orig overall channel deviation vs robust SD';
    figure ('Name', baseTitle);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset ratios: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Dataset ratios', 'Median of dataset ratios', 'Location', 'NorthWest')
    hold off

    %% Plot medians of window channel deviation
    minDev = min(min(statistics(:, s.medWinDevOrig)), ...
                 min(statistics(:, s.medWinDevRef)));
    maxDev = max(max(statistics(:, s.medWinDevOrig)), ...
                 max(statistics(:, s.medWinDevRef)));
    baseTitle = 'Median window channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.medWinDevOrig), statistics(:, s.medWinDevRef), 'ok')
    plot(median(statistics(:, s.medWinDevOrig)),median(statistics(:, s.medWinDevRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    xlabel(statisticsTitles{s.medWinDevOrig});
    ylabel(statisticsTitles{s.medWinDevRef});
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(median(statistics(:, s.medWinDevOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.medWinDevRef))) '(ref)]']});
     legend('Dataset median', 'Median of dataset medians', 'Location', 'NorthWest')
    hold off
    %% Plot robust SD of median window channel deviations
    minSDR = min(min(statistics(:, s.rSDWinDevOrig)), ...
                 min(statistics(:, s.rSDWinDevRef)));
    maxSDR = max(max(statistics(:, s.rSDWinDevOrig)), ...
                 max(statistics(:, s.rSDWinDevRef)));
    baseTitle = 'Robust SD Median window channel deviation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.rSDWinDevOrig), statistics(:, s.rSDWinDevRef), 'ok')

    plot(median(statistics(:, s.rSDWinDevOrig)), ...
         median(statistics(:, s.rSDWinDevRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    xlabel(statisticsTitles{s.rSDWinDevOrig});
    ylabel(statisticsTitles{s.rSDWinDevRef});
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset SDRs: ' num2str(median(statistics(:, s.rSDWinDevOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.rSDWinDevRef))) '(ref)]']});
     legend('Dataset SDR', 'Median of dataset SDRs', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of window channel deviations
    baseTitle = 'Ratio of ref/orig window channel deviations vs SDRs';
    figure ('Name', baseTitle);
    medRatio = statistics(:, s.medWinDevRef)./statistics(:, s.medWinDevOrig);
    sdrRatio = statistics(:, s.rSDWinDevRef)./statistics(:, s.rSDWinDevOrig);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset ratios: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Dataset ratios', 'Median of dataset ratios', 'Location', 'NorthWest')
    hold off
    
    %% Plot before and after median max correlation
    minCorr = min(min(statistics(:, s.medCorOrig), ...
                  min(statistics(:, s.medCorRef))));
    baseTitle = 'Median max window correlation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.medCorOrig), statistics(:, s.medCorRef), 'ok')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(median(statistics(:, s.medCorOrig)), ...
         median(statistics(:, s.medCorRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    xlabel(statisticsTitles{s.medCorOrig});
    ylabel(statisticsTitles{s.medCorRef});
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(median(statistics(:, s.medCorOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.medCorRef))) '(ref)]']});
    legend('Dataset median', 'Median of dataset medians', 'Location', 'NorthWest')

    hold off
    
    %% Plot before and after mean max correlation
    minCorr = min(min(statistics(:, s.aveCorOrig), ...
                  min(statistics(:, s.aveCorRef))));
    baseTitle = 'Mean max window correlation';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.aveCorOrig), statistics(:, s.aveCorRef), 'ok')
    set(gca, 'XLim', [minCorr, 1], 'XLimMode', 'manual', ...
        'YLim', [minCorr, 1], 'YLimMode', 'manual');
    plot(mean(statistics(:, s.aveCorOrig)), mean(statistics(:, s.aveCorRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minCorr; 1], [minCorr; 1], 'LineWidth', 3, ...
        'Color', divideColor);
    xlabel(statisticsTitles{s.aveCorOrig});
    ylabel(statisticsTitles{s.aveCorRef});
    title({collectionTitle; baseTitle; ...
        ['[Mean of dataset means: ' num2str(mean(statistics(:, s.aveCorOrig))) '(orig) ' ...
        num2str(mean(statistics(:, s.aveCorRef))) '(ref)]']});
     legend('Dataset mean', 'Mean of dataset means', 'Location', 'NorthWest')

    hold off

    %% Plot median overall channel noisiness
    minDev = min(min(statistics(:, s.medHFOrig)),...
                 min(statistics(:, s.medHFRef)));
    maxDev = max(max(statistics(:, s.medHFOrig)), ...
                 max(statistics(:, s.medHFRef)));
    baseTitle = 'Median overall noisiness';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.medHFOrig), statistics(:, s.medHFRef), 'ok')
    xlabel(statisticsTitles{s.medHFOrig});
    ylabel(statisticsTitles{s.medHFRef});
    title(collectionTitle)
    plot(median(statistics(:, s.medHFOrig)), median(statistics(:, s.medHFRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(median(statistics(:, s.medHFOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.medHFRef))) '(ref)]']});
    legend('Dataset median', 'Median of dataset medians', 'Location', 'NorthWest')
    hold off

    %% Plot robust SD of overall channel noisness
    minSDR = min(min(statistics(:, s.rSDHFOrig)), ...
                 min(statistics(:, s.rSDHFRef)));
    maxSDR = max(max(statistics(:, s.rSDHFOrig)), ...
                 max(statistics(:, s.rSDHFRef)));
    baseTitle = 'SDR overall channel noisiness';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.rSDHFOrig), statistics(:, 16), 'ok')
    xlabel(statisticsTitles{s.rSDHFOrig});
    ylabel(statisticsTitles{s.rSDHFRef});
    plot(median(statistics(:, s.rSDHFOrig)), ...
         median(statistics(:, s.rSDHFRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset SDRs: ' num2str(median(statistics(:, s.rSDHFOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.rSDHFRef))) '(ref)]']});
    legend('Dataset SDR', 'Median of dataset SDRs', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of overall channel noisiness
    medRatio = statistics(:, s.medHFRef)./statistics(:, s.medHFOrig);
    sdrRatio = statistics(:, s.rSDHFRef)./statistics(:, s.rSDHFOrig);
    baseTitle = 'Ratio of ref/orig overall channel noisiness vs robust SD';
    figure ('Name', baseTitle);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset ratios: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Dataset ratio ', 'Median of dataset ratios', 'Location', 'NorthWest')
    hold off

    %% Plot medians of window channel noisiness
    minDev = min(min(statistics(:, s.medWinHFOrig)), ...
                 min(statistics(:, s.medWinHFRef)));
    maxDev = max(max(statistics(:, s.medWinHFOrig)), ...
                 max(statistics(:, s.medWinHFRef)));
    baseTitle = 'Median window channel noisiness';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.medWinHFOrig), statistics(:, s.medWinHFRef), 'ok')
    plot(median(statistics(:, s.medWinHFOrig)), ...
         median(statistics(:, s.medWinHFRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minDev; maxDev], [minDev; maxDev], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minDev, maxDev], 'XLimMode', 'manual', ...
        'YLim', [minDev, maxDev], 'YLimMode', 'manual');
    xlabel(statisticsTitles{s.medWinHFOrig});
    ylabel(statisticsTitles{s.medWinHFRef});
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset medians: ' num2str(median(statistics(:, s.medWinHFOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.medWinHFRef))) '(ref)]']});
     legend('Dataset median', 'Median of dataset medians', 'Location', 'NorthWest')
    hold off
    %% Plot robust SD of median window channel noisiness
    minSDR = min(min(statistics(:, s.rSDWinHFOrig)), ...
                 min(statistics(:, s.rSDWinHFRef)));
    maxSDR = max(max(statistics(:, s.rSDWinHFOrig)), ...
                 max(statistics(:, s.rSDWinHFRef)));
    baseTitle = 'Robust SD Median window channel noisiness';
    figure ('Name', baseTitle);
    hold on
    plot(statistics(:, s.rSDWinHFOrig), statistics(:, s.rSDWinHFRef), 'ok')

    plot(median(statistics(:, s.rSDWinHFOrig)), ...
         median(statistics(:, s.rSDWinHFRef)), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    line([minSDR; maxSDR], [minSDR; maxSDR], 'LineWidth', 3, ...
        'Color', divideColor);
    set(gca, 'XLim', [minSDR, maxSDR], 'XLimMode', 'manual', ...
        'YLim', [minSDR, maxSDR], 'YLimMode', 'manual');
    xlabel(statisticsTitles{s.rSDWinHFOrig});
    ylabel(statisticsTitles{s.rSDWinHFRef});
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset SDRs: ' num2str(median(statistics(:, s.rSDWinHFOrig))) '(orig) ' ...
        num2str(median(statistics(:, s.rSDWinHFRef))) '(ref)]']});
     legend('Dataset SDR', 'Median of dataset SDRs', 'Location', 'NorthWest')
    hold off
    
   %% Plot ratios (ref/org) of median vs robust SD of window noisiness
    baseTitle = 'Ratio of ref/orig window channel median vs SDR window noisiness';
    figure ('Name', baseTitle);
    medRatio = statistics(:, s.medWinHFRef)./statistics(:, s.medWinHFOrig);
    sdrRatio = statistics(:, s.rSDWinHFOrig)./statistics(:, s.rSDWinHFRef);
    hold on
    plot(medRatio, sdrRatio, 'ok')
    xlabel('Median ratio ref/orig');
    ylabel('SDR ratio ref/orig');
    plot(median(medRatio), median(sdrRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Median of dataset ratios: ' num2str(median(medRatio)) '(median) ' ...
        num2str(median(sdrRatio)) '(sdr)]']});
    legend('Dataset ratio', 'Median of dataset ratios', 'Location', 'NorthWest')
    hold off

    
%% Plot ratios sdr/med window channel deviations ref versus orig
    baseTitle = 'Ref ratio of sdr/med channel deviations to orig ratio';
    figure ('Name', baseTitle);
    refRatio = statistics(:, s.rSDWinDevRef)./statistics(:, s.medWinDevRef);
    origRatio = statistics(:, s.rSDWinDevOrig)./statistics(:, s.medWinDevOrig);
    hold on
    plot(refRatio, origRatio, 'ok')
    xlabel('SDR/Median ref ratio');
    ylabel('SDR/Median orig ratio');
    plot(median(refRatio), median(origRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    title({collectionTitle; baseTitle; ...
        ['[Window channel deviations SDR/Median ratios: ' num2str(median(refRatio)) '(ref) ' ...
        num2str(median(origRatio)) '(orig)]']});
    legend('Dataset ratios', 'Median of dataset ratios', 'Location', 'NorthWest')
    hold off
    
%% Plot median window correlation versus ratio sdr/ref window channel deviations 
    baseTitle = 'Comparison of channel deviation and correlation';
    figure ('Name', baseTitle);
    refRatio = statistics(:, s.rSDWinDevRef)./statistics(:, s.medWinDevRef);
    origRatio = statistics(:, s.rSDWinDevOrig)./statistics(:, s.medWinDevOrig);
    hold on
    plot(statistics(:, s.medCorRef), refRatio, 'ok')
        plot(median(statistics(:, s.medCorRef)), median(refRatio), ...
        '+r', 'MarkerSize', 14, 'LineWidth', 3);
    plot(statistics(:, s.medCorOrig), origRatio, 'sb')
    plot( median(statistics(:, s.medCorOrig)), median(origRatio), ...
        'xr', 'MarkerSize', 14, 'LineWidth', 3);
    xlabel('Median min window correlation');
    ylabel('SDR/Median ratio');
    title({collectionTitle; baseTitle; ...
        ['[Window channel deviations SDR/Median ratios: ' num2str(median(refRatio)) '(ref) ' ...
        num2str(median(origRatio)) '(orig)]']});
    legend('Referenced', 'Median referenced', 'Original', 'Median original', ...
           'Location', 'NorthWest')
    hold off
    
