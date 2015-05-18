function showCollectionBoxplots(collections, legendString, collectionColors)
% Displays the items in collectionStats using boxplots

%% Overall median channel deviations
[dataGroups1, dataPoints1] = getDataGroups(collections, 'medDev');
baseTitle = 'Median channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints1, dataGroups1, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors, ...
    'datalim', [0, 50]);
set(gca, 'FontSize', 12)
xlabel('Median overall channel deviation', 'FontSize', 12)

%% Overall rSD channel deviations
[dataGroups2, dataPoints2] = getDataGroups(collections, 'rSDDev');
baseTitle = 'Robust SD channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Overall robust SD channel deviation', 'FontSize', 12)

%% Overall rSD/med channel deviation ratio
baseTitle = 'Median overall channel deviation ratio';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2./dataPoints1, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Ratio rSD/med overall channel deviation', 'FontSize', 12)

%% Window median channel deviations
[dataGroups1, dataPoints1] = getDataGroups(collections, 'medWinDev');
baseTitle = 'Median window channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints1, dataGroups1, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors, ...
    'datalim', [0, 50]);
set(gca, 'FontSize', 12)
xlabel('Median window channel deviation', 'FontSize', 12)

%% Window rSD channel deviations
[dataGroups2, dataPoints2] = getDataGroups(collections, 'rSDWinDev');
baseTitle = 'Robust SD window channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Robust SD window channel deviation', 'FontSize', 12)


%% Window rSD/med channel deviation ratio
baseTitle = 'Median window channel deviation ratio';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2./dataPoints1, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Ratio rSD/med window channel deviation', 'FontSize', 12)

%% Window median maximum channel correlations
[dataGroups, dataPoints] = getDataGroups(collections, 'medCor');
baseTitle = 'Median maximum window channel correlation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Median maximum channel correlation', 'FontSize', 12)

%% Window average maximum channel correlattions
[dataGroups, dataPoints] = getDataGroups(collections, 'aveCor');
baseTitle = 'Average maximum window channel correlation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Average maximum channel correlation', 'FontSize', 12)


%% Overall median channel HF noise
[dataGroups1, dataPoints1] = getDataGroups(collections, 'medHF');
baseTitle = 'Median channel HF noise';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints1, dataGroups1, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Median overall channel HF noise', 'FontSize', 12)

%% Overall rSD channel HF noise
[dataGroups2, dataPoints2] = getDataGroups(collections, 'rSDHF');
baseTitle = 'Overall robust SD channel HF noise';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Overall robust SD channel HF noise', 'FontSize', 12)

%% Overall rSD/med channel HF noise ratio
baseTitle = 'Median overall channel HF noise ratio';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2./dataPoints1, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Ratio rSD/med overall channel HF noise', 'FontSize', 12)

%% Window median channel HF noise
[dataGroups1, dataPoints1] = getDataGroups(collections, 'medWinHF');
baseTitle = 'Median window channel HF noise';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints1, dataGroups1, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors, ...
    'datalim', [0, 50]);
set(gca, 'FontSize', 12)
xlabel('Median window channel HF noise', 'FontSize', 12)

%% Window rSD channel HF noise
[dataGroups2, dataPoints2] = getDataGroups(collections, 'rSDWinHF');
baseTitle = 'Robust SD window channel HF noise';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Robust SD window channel HF noise', 'FontSize', 12)


%% Window rSD/med channel HF noise ratio
baseTitle = 'Median window channel HF noise ratio';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints2./dataPoints1, dataGroups2, 'labels', legendString, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Ratio rSD/med window channel HF noise', 'FontSize', 12)



end