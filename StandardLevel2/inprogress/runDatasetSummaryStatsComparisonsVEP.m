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

statFiles = {'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2Reports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPStandardLevel2MastoidReferenceReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidReferenceReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2MastoidBeforeReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceReports\\dataStatistics.mat'; ...
             'N:\\ARLAnalysis\\VEP\\VEPSpecificLevel2AverageReferenceAfterMastoidReports\\dataStatistics.mat'};
statNames = {'collectionStats'; 'collectionStats'; 'collectionStats'; 'collectionStats'; 'collectionStats'; 'collectionStats'};
legendString = {'Robust', 'M-Robust', 'Mastoid', 'M-Before', 'Average', 'M-Average'};
%% Read the collectionStats files
collections = cell(length(statFiles), 1);
for k = 1:length(collections)
    fprintf('%d: %s\n', k, statFiles{k});
    x = load(statFiles{k});
    collections{k} = x.(statNames{k});
end
markerColors =  [ ...
    0       0         0.8
    0.25    0.75       1; ...
    0       0.55       0; ...
    0.25    1         0.25; ...
    1       1         0.25; ...
    0.8     0,        0.8];

markerShapes = {'s', 'o', '^', 'v', '>', '<'};
markerSizes = [8, 6, 6, 6, 6, 6];
bigMarkerSize = 14;
divideColor = [0.85, 0.85, 0.85];
s = collections{k}.statisticsIndex;
%% Plot ratios (ref/org) of median vs robust SD of window channel deviations
medRatios = cell(length(collections), 1);
sdrRatios = cell(length(collections), 1);
for k = 1:length(collections)
    medRatios{k} = collections{k}.statistics(:, s.medWinDevRef)./collections{1}.statistics(:, s.medWinDevOrig);
    sdrRatios{k} = collections{k}.statistics(:, s.rSDWinDevRef)./collections{1}.statistics(:, s.rSDWinDevOrig);
end
baseTitle = 'Ratio of ref/orig window channel deviations vs SDRs';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(medRatios{k}, sdrRatios{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), 'MarkerSize', markerSizes(k), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot(median(medRatios{k}), median(sdrRatios{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(medRatios{k}), median(sdrRatios{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel('Median (Referenced/Filtered only)');
yg = ylabel('SDR (Referenced/Filtered only)');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString, 'Location', 'NorthWest')
hold off
for k = 1:length(collections)
    fprintf('%d: %s corr = %g\n', k, legendString{k}, corr(medRatios{k}, sdrRatios{k}));
end
box on

%% Comparison of robust window channel deviations
meds = cell(length(collections), 1);
for k = 1:length(collections)
    meds{k} = collections{k}.statistics(:, s.medWinDevRef);
end
baseTitle = 'Median robust channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 2:length(collections)
  plot(meds{1}, meds{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), 'MarkerSize', markerSizes(k), ...
      'LineStyle', 'none');
end

for k = 2:length(collections)
   plot(median(meds{1}), median(meds{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(meds{1}), median(meds{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel(legendString{1});
yg = ylabel('Other versions');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString(2:end), 'Location', 'NorthWest')
hold off
box on

%% Plot comparison SD of window channel deviations
sdrs = cell(length(collections), 1);
for k = 1:length(collections)
    sdrs{k} = collections{k}.statistics(:, s.rSDWinDevRef);
end
baseTitle = 'SDR window channel deviation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 2:length(collections)
  plot(sdrs{1}, sdrs{k}, 'Marker', markerShapes{k}, ...
      'MarkerFaceColor', markerColors(k, :), 'MarkerSize', markerSizes(k), ...
      'LineStyle', 'none');
end

for k = 2:length(collections)
   plot(median(sdrs{1}), median(sdrs{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(sdrs{1}), median(sdrs{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel(legendString{1});
yg = ylabel('Other versions');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString(2:end), 'Location', 'NorthWest')
hold off
box on
%% Plot ratios ref med/sdr versus orig med/sdr median vs robust SD of window channel deviations
refRatios = cell(length(collections), 1);
origRatios = cell(length(collections), 1);
for k = 1:length(collections)
    refRatios{k} = collections{k}.statistics(:, s.medWinDevRef)./collections{k}.statistics(:, s.rSDWinDevRef);
    origRatios{k} = collections{1}.statistics(:, s.medWinDevOrig)./collections{1}.statistics(:, s.rSDWinDevOrig);
end
baseTitle = 'Reference ratio med/sdr versus orig ratio med/sdr channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(origRatios{k}, refRatios{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot(median(origRatios{k}), median(refRatios{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(origRatios{k}), median(refRatios{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xg = ylabel('Referenced/Interpolated');
yg = xlabel('Filtered only');
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

%% Plot comparison of med/sdr window channel deviations
baseTitle = 'med/sdr channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 2:length(collections)
  plot(refRatios{1}, refRatios{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 2:length(collections)
   plot(median(refRatios{1}), median(refRatios{k}), ...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(refRatios{2}), median(refRatios{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xg = ylabel('Other versions');
yg = xlabel(legendString{1});
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
legend(legendString(2:end), 'Location', 'NorthWest')
box on
hold off

%% Plot ratios ref med/sdr versus orig med/sdr median vs robust SD of window channel deviations
ref1Ratios = cell(length(collections), 1);
orig1Ratios = cell(length(collections), 1);
for k = 1:length(collections)
    ref1Ratios{k} = collections{k}.statistics(:, s.rSDWinDevRef)./collections{k}.statistics(:, s.medWinDevRef);
    orig1Ratios{k} = collections{1}.statistics(:, s.rSDWinDevOrig)./collections{1}.statistics(:, s.medWinDevOrig);
end
baseTitle = 'Reference ratio sdr/med versus orig ratio sdr/med channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(orig1Ratios{k}, ref1Ratios{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 1:length(collections)
   plot( median(orig1Ratios{k}), median(ref1Ratios{k}),...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(orig1Ratios{k}), median(ref1Ratios{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
yg = ylabel('Referenced/Interpolated');
xg = xlabel('Filtered only');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString, 'Location', 'NorthWest')
box on
hold off

%% Plot comparison of first to rest of  med/sdr window deviation
baseTitle = 'Ratio sdr/med channel deviations';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 2:length(collections)
  plot(ref1Ratios{1}, ref1Ratios{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
      'LineStyle', 'none');
end

for k = 2:length(collections)
   plot( median(ref1Ratios{1}), median(ref1Ratios{k}),...
    'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', 'none');
  plot(median(ref1Ratios{1}), median(ref1Ratios{k}), ...
    '+', 'MarkerSize', bigMarkerSize, 'LineWidth', 4, ...
    'MarkerEdgeColor', [0, 0, 0], 'MarkerFaceColor', [0, 0, 0]);
end
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
maxLim = max(xLim(2), yLim(2));
minLim = min(xLim(1), yLim(1));
line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel(legendString{1});
yg = ylabel('Other versions');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
legend(legendString(2:end), 'Location', 'NorthWest')
box on
hold off

%% Plot before and after mean max correlation
refCorr = cell(length(collections), 1);
origCorr = cell(length(collections), 1);
minCorr = 1;
for k = 1:length(collections)
    refCorr{k} = collections{k}.statistics(:, s.aveCorRef);
    origCorr{k} = collections{1}.statistics(:, s.aveCorOrig);
    minCorr = min(minCorr, min(refCorr{k}));
    minCorr = min(minCorr, min(origCorr{k}));
end
baseTitle = 'Mean max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 1:length(collections)
  plot(origCorr{k}, refCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 1:length(collections)
        plot(mean(origCorr{k}), mean(refCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize', bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(mean(origCorr{k}), mean(refCorr{k}), ...
    '+', 'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel('Filtered only');
yg = ylabel('Referenced/Interpolated');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
legend(legendString, 'Location', 'NorthWest')
hold off

%% Comparison of first to rest of the  mean max correlation
baseTitle = 'Mean max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on
for k = 2:length(collections)
  plot(refCorr{1}, refCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 2:length(collections)
        plot(mean(refCorr{1}), mean(refCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize', bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(mean(refCorr{1}), mean(refCorr{k}), ...
    '+', 'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
xg = xlabel(legendString{1});
yg = ylabel('Other versions');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
legend(legendString(2:end), 'Location', 'SouthEast')
hold off
%% Plot before and after median max correlation
refMedCorr = cell(length(collections), 1);
origMedCorr = cell(length(collections), 1);
minMedCorr = 1;
for k = 1:length(collections)
    refMedCorr{k} = collections{k}.statistics(:, s.medCorRef);
    origMedCorr{k} = collections{1}.statistics(:, s.medCorOrig);
    minMedCorr = min(minMedCorr, min(refMedCorr{k}));
    minMedCorr = min(minMedCorr, min(origMedCorr{k}));
end
baseTitle = 'Median max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on

for k = 1:length(collections)
  plot(origMedCorr{k}, refMedCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 1:length(collections)
        plot(median(origMedCorr{k}), median(refMedCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(median(origMedCorr{k}), median(refMedCorr{k}), ...
    '+', 'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
legend(legendString, 'Location', 'NorthWest')
xg = xlabel('Only filtered');
yg = ylabel('Referenced/Interpolated');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
hold off

%% Plot comparison of first to others of median max correlation
baseTitle = 'Median max window correlation';
figure ('Name', baseTitle, 'Color', [1, 1, 1]);
hold on

for k = 2:length(collections)
  plot(refMedCorr{1}, refMedCorr{k}, 'Marker', markerShapes{k}, ...
      'MarkerSize', markerSizes(k), ...
      'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
end
for k = 1:length(collections)
        plot(median(refMedCorr{1}), median(refMedCorr{k}), 'Marker', markerShapes{k}, ...
     'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', 'none');
      plot(median(refMedCorr{1}), median(refMedCorr{k}), ...
    '+', 'MarkerSize',  bigMarkerSize, 'LineWidth', 4, 'MarkerEdgeColor', [0, 0, 0], ...
     'MarkerFaceColor', [0, 0, 0]);
end

xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
minVal = min(xLim(1), yLim(1));
gline = line([minVal; 1], [minVal; 1], [-1, -1], 'LineWidth', 3, ...
    'Color', divideColor);
legend(legendString(2:end), 'Location', 'SouthEast')
xg = xlabel(legendString{1});
yg = ylabel('Other versions');
set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
box on
hold off
