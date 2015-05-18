function showCollectionStatistics(collections, legendString, ...
    collectionColors, collectionMarkers)
% Displays the items in collectionStats uusing scatter plots

%% Plot median versus SDR overall channel deviation
baseTitle = 'Median versus SDR overall channel deviation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medDev), stats(:, s.rSDDev), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median overall channel deviation');
ylabel('Robust SD overall channel deviation');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medDev = median(stats(:, s.medDev));
    rSDDev = median(stats(:, s.rSDDev));
    plot(medDev, rSDDev, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median versus SDR window channel deviation
baseTitle = 'Median versus SDR window channel deviation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medWinDev), stats(:, s.rSDWinDev), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median window channel deviation');
ylabel('Robust SD window channel deviation');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medDev = median(stats(:, s.medWinDev));
    rSDDev = median(stats(:, s.rSDWinDev));
    plot(medDev, rSDDev, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median maximum correlation versus median window channel deviation
baseTitle = 'Median max correlation versus median window channel deviation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medCor), stats(:, s.medWinDev), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median maximum correlation');
ylabel('Median window channel deviation');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medDev = median(stats(:, s.medWinDev));
    medCor = median(stats(:, s.medCor));
    plot(medCor, medDev, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median maximum correlation versus window channel deviation ratio
baseTitle = 'Median max correlation versus window channel deviation ratio';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    devRatio = stats(:, s.rSDWinDev)./stats(:, s.medWinDev);
    plot(stats(:, s.medCor), devRatio, ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median maximum correlation');
ylabel('Window channel deviation ratio');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medRatio = median(stats(:, s.rSDWinDev)./stats(:, s.medWinDev));
    medCor = median(stats(:, s.medCor));
    plot(medCor, medRatio, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot average maximum correlation versus median window channel deviation
baseTitle = 'Average max correlation versus median window channel deviation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.aveCor), stats(:, s.medWinDev), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Average maximum correlation');
ylabel('Median window channel deviation');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medDev = median(stats(:, s.medWinDev));
    aveCor = median(stats(:, s.aveCor));
    plot(aveCor, medDev, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot average maximum correlation versus window channel deviation ratio
baseTitle = 'Average max correlation versus window channel deviation ratio';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    devRatio = stats(:, s.rSDWinDev)./stats(:, s.medWinDev);
    plot(stats(:, s.aveCor), devRatio, ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Average maximum correlation');
ylabel('Window channel deviation ratio');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medRatio = median(stats(:, s.rSDWinDev)./stats(:, s.medWinDev));
    aveCor = median(stats(:, s.aveCor));
    plot(aveCor, medRatio, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off


%% Plot median versus SDR overall HF noise
baseTitle = 'Median versus SDR overall HF noise';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medHF), stats(:, s.rSDHF), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median overall HF noise');
ylabel('Robust SD overall HF noise');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medHF = median(stats(:, s.medHF));
    rSDHF = median(stats(:, s.rSDHF));
    plot(medHF, rSDHF, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median versus SDR window HF noise
baseTitle = 'Median versus SDR window HF noise';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medWinHF), stats(:, s.rSDWinHF), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median window HF noise');
ylabel('Robust SD window HF noise');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medHF = median(stats(:, s.medWinHF));
    rSDHF = median(stats(:, s.rSDWinHF));
    plot(medHF, rSDHF, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median maximum correlation versus median window HF noise
baseTitle = 'Median max correlation versus median window HF noise';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.medCor), stats(:, s.medWinHF), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median maximum correlation');
ylabel('Median window channel HF noise');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medHF = median(stats(:, s.medWinHF));
    medCor = median(stats(:, s.medCor));
    plot(medCor, medHF, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot median maximum correlation versus window channel HF noise ratio
baseTitle = 'Median max correlation versus window channel HF noise ratio';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    HFRatio = stats(:, s.rSDWinHF)./stats(:, s.medWinHF);
    plot(stats(:, s.medCor), HFRatio, ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Median maximum correlation');
ylabel('Window channel HF noise ratio');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medRatio = median(stats(:, s.rSDWinHF)./stats(:, s.medWinHF));
    medCor = median(stats(:, s.medCor));
    plot(medCor, medRatio, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot average maximum correlation versus median window channel HF noise
baseTitle = 'Average max correlation versus median window channel HF noise';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    plot(stats(:, s.aveCor), stats(:, s.medWinHF), ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Average maximum correlation');
ylabel('Median window channel HF noise');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medHF = median(stats(:, s.medWinHF));
    aveCor = median(stats(:, s.aveCor));
    plot(aveCor, medHF, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off

%% Plot average maximum correlation versus window channel HF noise ratio
baseTitle = 'Average max correlation versus window channel HF noise ratio';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    HFRatio = stats(:, s.rSDWinHF)./stats(:, s.medWinHF);
    plot(stats(:, s.aveCor), HFRatio, ...
        'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'LineStyle', 'none', ...
        'MarkerSize', 12, 'LineWidth', 2);
end
xlabel('Average maximum correlation');
ylabel('Window channel HF noise ratio');
title(baseTitle, 'interpreter', 'none')
for k = 1:length(collections)
    stats = collections{k}.statistics;
    s = collections{k}.statisticsIndex;
    medRatio = median(stats(:, s.rSDWinHF)./stats(:, s.medWinHF));
    aveCor = median(stats(:, s.aveCor));
    plot(aveCor, medRatio, 'Color', collectionColors(k, :), ...
        'Marker', collectionMarkers{k}, 'MarkerSize', 14, 'LineWidth', 3);
end
legend(legendString, 'Location', 'NorthEast')
box on
hold off
