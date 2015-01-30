%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
% statFiles = {'N:\\ARLAnalysis\\NCTU\\Level2A\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\test\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\train\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\\VEPStandardLevel2AReports\\dataStatistics.mat'; ...
%              'N:\\ARL_BCIT_Program\\Level2AReports\\T1\\dataStatistics.mat'; ...
%              'N:\\ARL_BCIT_Program\\Level2AReports\\T2\\dataStatistics.mat'; ...
%              'N:\\ARL_BCIT_Program\\Level2AReports\\T3\\dataStatistics.mat'};
% 
% statNames = {'collectionStats'; ...
%              'collectionStatsTest'; 'collectionStatsTrain'; ...
%              'collectionStats'; ...
%              'collectionStats'; 'collectionStats'; 'collectionStats'};
%
%legendString = {'NCTU', 'BCITest', 'BCITrain', 'VEP', 'BCIT-T1', 'BCIT-T2', 'BCIT-T3'};
% legendString = {'BCITest', 'BCITrain'};
% statFiles = {'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\test\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\train\\dataStatistics.mat'};
% statNames = {'collectionStatsTest'; 'collectionStatsTrain'};

statFiles = {'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2AReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2MastoidReferenceReports\\dataStatistics.mat';
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports\\dataStatistics.mat'};
statNames = {'collectionStats'; 'collectionStats'; 'collectionStats'; 'collectionStats'};
legendString = {'VEP-R', 'VEP-A', 'VEP-MR', 'VEP-M'};
%% Read the collectionStats files
collections = cell(length(statFiles), 1);
for k = 1:length(collections)
    x = load(statFiles{k});
    collections{k} = x.(statNames{k});
end
markerColors =  [ ...
    0     0         1
    0.25    0.5    1; ...
    1    0     0; ...
    1    0.5    0.25];

markerShapes = {'s', 'd', 'o', '^', '<', '>', 'v'};
divideColor = [0.85, 0.85, 0.85];
s = collections{k}.statisticsIndex;
%% Plot ratios (ref/org) of median vs robust SD of window channel deviations
medRatios = cell(length(collections), 1);
sdrRatios = cell(length(collections), 1);
for k = 1:length(collections)
    medRatios{k} = collections{k}.statistics(:, s.medWinDevRef)./collections{k}.statistics(:, s.medWinDevOrig);
    sdrRatios{k} = collections{k}.statistics(:, s.rSDWinDevRef)./collections{k}.statistics(:, s.rSDWinDevOrig);
end
baseTitle = 'Ratio of ref/orig window channel deviations vs SDRs';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(medRatios{k}, sdrRatios{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot(median(medRatios{k}), median(sdrRatios{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(medRatios{k}), median(sdrRatios{k}), ...
    '+', 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel('Median ratio ref/orig');
yg = ylabel('SDR ratio ref/orig');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString, 'Location', 'NorthWest')
hold off
for k = 1:length(collections)
    fprintf('%d: %s corr = %g\n', k, legendString{k}, corr(medRatios{k}, sdrRatios{k}));
end
box on
%% Plot ratios ref med/sdr versus orig med/sdr median vs robust SD of window channel deviations
refRatios = cell(length(collections), 1);
origRatios = cell(length(collections), 1);
for k = 1:length(collections)
    refRatios{k} = collections{k}.statistics(:, s.medWinDevRef)./collections{k}.statistics(:, s.rSDWinDevRef);
    origRatios{k} = collections{k}.statistics(:, s.medWinDevOrig)./collections{k}.statistics(:, s.rSDWinDevOrig);
end
baseTitle = 'Reference ratio med/sdr versus orig ratio med/sdr channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(origRatios{k}, refRatios{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot(median(origRatios{k}), median(refRatios{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(origRatios{k}), median(refRatios{k}), ...
    '+', 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xg = ylabel('Reference med/SDR');
yg = xlabel('Original med/SDR');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
legend(legendString, 'Location', 'NorthWest')
box on
hold off

%% Plot ratios ref med/sdr versus orig med/sdr median vs robust SD of window channel deviations
ref1Ratios = cell(length(collections), 1);
orig1Ratios = cell(length(collections), 1);
for k = 1:length(collections)
    ref1Ratios{k} = collections{k}.statistics(:, s.rSDWinDevRef)./collections{k}.statistics(:, s.medWinDevRef);
    orig1Ratios{k} = collections{k}.statistics(:, s.rSDWinDevOrig)./collections{k}.statistics(:, s.medWinDevOrig);
end
baseTitle = 'Reference ratio sdr/med versus orig ratio sdr/med channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(orig1Ratios{k}, ref1Ratios{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot( median(orig1Ratios{k}), median(ref1Ratios{k}),...
    'Marker', markerShapes{k}, 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(orig1Ratios{k}), median(ref1Ratios{k}), ...
    '+', 'MarkerSize', 14, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
yg = ylabel('Reference SDR/med');
xg = xlabel('Original SDR/med');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString, 'Location', 'NorthWest')
box on
hold off

%% Plot before and after mean max correlation
refCorr = cell(length(collections), 1);
origCorr = cell(length(collections), 1);
minCorr = 1;
for k = 1:length(collections)
    refCorr{k} = collections{k}.statistics(:, s.aveCorRef);
    origCorr{k} = collections{k}.statistics(:, s.aveCorOrig);
    minCorr = min(minCorr, min(refCorr{k}));
    minCorr = min(minCorr, min(origCorr{k}));
end
baseTitle = 'Mean max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(origCorr{k}, refCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 1:length(collections)
        plot(mean(origCorr{k}), mean(refCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize', 14, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(mean(origCorr{k}), mean(refCorr{k}), ...
    '+', 'MarkerSize', 14, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel('Mean window channel correlation (original)');
yg = ylabel('Mean window channel correlation (referenced)');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
legend(legendString, 'Location', 'NorthWest')
hold off

%% Plot before and after median max correlation
refMedCorr = cell(length(collections), 1);
origMedCorr = cell(length(collections), 1);
minMedCorr = 1;
for k = 1:length(collections)
    refMedCorr{k} = collections{k}.statistics(:, s.medCorRef);
    origMedCorr{k} = collections{k}.statistics(:, s.medCorOrig);
    minMedCorr = min(minMedCorr, min(refMedCorr{k}));
    minMedCorr = min(minMedCorr, min(origMedCorr{k}));
end
baseTitle = 'Median max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on

for k = 1:length(collections)
  plot(origMedCorr{k}, refMedCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 1:length(collections)
        plot(median(origMedCorr{k}), median(refMedCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize', 14, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(median(origMedCorr{k}), median(refMedCorr{k}), ...
    '+', 'MarkerSize', 14, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
gline = line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
legend(legendString, 'Location', 'NorthWest')
xg = xlabel('Median window channel correlation (original)');
yg = ylabel('Median window channel correlation (referenced)');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
hold off

