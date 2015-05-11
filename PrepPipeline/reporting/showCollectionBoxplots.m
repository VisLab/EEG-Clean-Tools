function showCollectionBoxplots(collectionStats, legendString, collectionColors)
% Displays the items in collectionStats using boxplots

%% Overall ratio sdr/median channel deviations
titles = legendString;
totalPoints = 0;
data = collectionStats.refRatiosDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'sdr/med ratio channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('SDR/Median channel deviation', 'FontSize', 12)

%% Window ratio sdr/median channel deviations
titles = legendString;
totalPoints = 0;
data = collectionStats.refRatiosWinDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'SDR/Median ratio channel deviations';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('SDR/Median window channel deviation', 'FontSize', 12)

%% Window ratio sdr/median original channel deviations
titles = legendString;
totalPoints = 0;
data = collectionStats.origRatiosWinDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'SDR/Median ratio unreferenced window channel deviations';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('SDR/Median unreferenced window channel deviation', 'FontSize', 12)

%% Display the HF sdr/median HF ratios
titles = legendString;
totalPoints = 0;
data = collectionStats.refRatiosHF;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'SDR/Median ratio channel HF scores';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
set(gca, 'FontSize', 12)
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('SDR/Median HF scores', 'FontSize', 12)

%% Display the HF sdr/median ratios
titles = legendString;
totalPoints = 0;
data = collectionStats.refRatiosWinHF;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Window SDR/Median ratio channel HF scores';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
set(gca, 'FontSize', 12)
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('SDR/Median window HF scores', 'FontSize', 12)

%% Display the mean max correlation
titles = legendString;
totalPoints = 0;
data = collectionStats.refCorrAve;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Window mean max correlation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
set(gca, 'FontSize', 12)
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', collectionColors);
set(gca, 'FontSize', 12)
xlabel('Mean max correlation', 'FontSize', 12)


%% Display the median deviation distribution
titles = legendString;
totalPoints = 0;
data = collectionStats.refDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Median channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', ...
    collectionColors, 'datalim', [0, 20], 'extrememode', 'clip');
xlabel('Median channel deviation', 'FontSize', 12)
set(gca, 'XLim', [0, 21], 'XLimMode', 'manual')

%% Display the window median deviation distribution
titles = legendString;
totalPoints = 0;
data = collectionStats.refWinDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Median window channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', ...
    collectionColors, 'datalim', [0, 20], 'extrememode', 'clip');
xlabel('Median window channel deviation', 'FontSize', 12)
set(gca, 'XLim', [0, 21], 'XLimMode', 'manual')


%% Display the original window median deviation distribution
titles = legendString;
totalPoints = 0;
data = collectionStats.origWinDev;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Unreferenced median window channel deviation';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', ...
    collectionColors, 'datalim', [0, 20], 'extrememode', 'clip');
xlabel('Unreferenced median window channel deviation', 'FontSize', 12)
set(gca, 'XLim', [0, 21], 'XLimMode', 'manual')

%% Display the HF distribution
titles = legendString;
totalPoints = 0;
data = collectionStats.refHF;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Median HF score';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', ...
    collectionColors, 'extrememode', 'clip');
xlabel('Median HF score', 'FontSize', 12)

%% Display the HF distribution
titles = legendString;
totalPoints = 0;
data = collectionStats.refWinHF;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data{k});
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
    startGroup = endGroup + 1;
end
baseTitle = 'Median window HF score';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on', 'Colors', ...
    collectionColors, 'extrememode', 'clip');
xlabel('Median window HF score', 'FontSize', 12)