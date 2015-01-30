%% Run through statistics and compare bad channels from different methods
pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% NCTU comparison
compareIndex = 1;
statFiles = {'N:\\ARLAnalysis\\NCTU\\Level2\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\NCTU\\SpecificLevel2MastoidBefore\\dataStatistics.mat'; ...
            'N:\\ARLAnalysis\\NCTU\\SpecificLevel2Average\\dataStatistics.mat'};
statNames = {'collectionStats'; 'collectionStats'; 'collectionStats'};
legendString = {'Robust', 'Mastoid', 'Average'};

%% VEP dataset comparison
% compareIndex = 1;
% statFiles = {'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2Reports\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceReports\\dataStatistics.mat'};
% statNames = {'collectionStats'; 'collectionStats'; 'collectionStats'};
% legendString = {'Robust', 'Mastoid', 'Average'};
%% Plot properties
markerShapes = {'s', 'o', '^', 'v', '>', '<'};
lineWidth = 2;
markerColors =  [ ...
    0       0         0.8
    0.25    0.75       1; ...
    0       0.55       0; ...
    0.25    1         0.25; ...
    1       1         0.25; ...
    0.8     0,        0.8];       
%% Read the collectionStats files
collections = cell(length(statFiles), 1);
badChannels = cell(length(statFiles), 1);
for k = 1:length(collections)
    x = load(statFiles{k});
    collections{k} = x.(statNames{k});
    badChannels{k} = {collections{k}.noisyChannels.badChannelNumbers};
end

%% Extract the bad channels and calculate fractions
baseTitle = 'Bad channel comparison across methods';

base = badChannels{compareIndex};
baseNumber = zeros(1, length(collections));
agreedOn = zeros(length(base), length(collections));
notInBase = zeros(length(base), length(collections));
for j = 1:length(base)
    baseNumber(j) = length(base{j});
end
allChannels = base;
for k = 1:length(collections)
    for j = 1:length(base)
        agreedOn(j, k) = length(intersect(base{j}, badChannels{k}{j}));
        notInBase(j, k) = length(setdiff(badChannels{k}{j}, base{j}));
        allChannels{j} = union(allChannels{j}, badChannels{k}{j});
    end
end

totalChannels = 0;
badByCollection = zeros(1, length(collections));

%% Plot a figure showing the bad channels from different methods
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
bar(baseNumber, 'EdgeColor', [0.6, 0.6, 0.6], 'FaceColor', [0.8, 0.8, 0.8])
restIndices = setdiff(1:length(collections), compareIndex);
for k = restIndices
    plot(-notInBase(:, k), 'Marker', markerShapes{k}, ...
        'MarkerEdgeColor', markerColors(k,:), 'MarkerFaceColor', markerColors(k, :), ...
        'LineWidth', lineWidth, 'LineStyle', '-', 'Color', markerColors(k, :));
end
for k = restIndices
    h= plot(agreedOn(:, k), 'Marker', markerShapes{k}, ...
        'MarkerEdgeColor', markerColors(k,:), 'MarkerFaceColor', markerColors(k, :), ...
        'LineWidth', lineWidth, 'LineStyle', '-', 'Color', markerColors(k, :));
end
hold off
legend(legendString, 'Location', 'NorthWest')
set(gca, 'XLim', [0, length(baseNumber) + 1], 'XLimMode', 'Manual')
xlabel('Dataset', 'FontSize', 12, 'FontWeight', 'Bold')
ylabel('Number of bad channels', 'FontSize', 12, 'FontWeight', 'Bold')
box on
