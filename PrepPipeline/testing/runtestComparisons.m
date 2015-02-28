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
% legendString = {'BCITest', 'BCITrain'};
% statFiles = {'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\test\\dataStatistics.mat'; ...
%              'N:\\ARLAnalysis\KaggleBCIStandardLevel2\\reports\\train\\dataStatistics.mat'};
% statNames = {'collectionStatsTest'; 'collectionStatsTrain'};
%legendString = {'NCTU', 'BCITest', 'BCITrain', 'VEP', 'BCIT-T1', 'BCIT-T2', 'BCIT-T3'};
%-----------------------------------NCTU-------------------------------------

statFiles = {
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p5Reports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5Reports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustCutoff0p3Reports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p3Reports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p2Reports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobustReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrendedReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrendedReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrendedReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrendedReports\\dataStatistics.mat', ...
    'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverageReports\\dataStatistics.mat'};
 
legendString = { ...
     'Robust', 'D-Robust', 'Robust-0.5', 'D-Robust-0.5', ...
     'Robust-0.3', 'D-Robust-0.3', 'D-Robust-0.2', ...
     'M-Robust', 'MD-Robust', 'Mastoid', 'D-Mastoid', ...
     'M-Before', 'MD-Before', 'Average', 'D-Average', 'M-average' ...
     };    
 
statNames = { ...
    'collectionStats'; 'collectionStats'; 'collectionStats'; ...
    'collectionStats'; 'collectionStats'; 'collectionStats'; ...
    'collectionStats'; 'collectionStats'; 'collectionStats'; ...
    'collectionStats'; 'collectionStats'; 'collectionStats'; ...
    'collectionStats'; 'collectionStats'; 'collectionStats'; ...
     'collectionStats'; ...
     };
         
% %%
% statFiles = {
%     'N:\\ARLAnalysis\\NCTU\\NCTUStandardLevel2\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\NCTU\\SpecificLevel2Average\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\NCTU\\SpecificLevel2MastoidBefore\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2RobustReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPStandardLevel2MastoidBeforeRobustReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2AverageReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNew\\VEPSpecificLevel2MastoidBeforeAverageReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2RobustDetrendedCutoff0p5Reports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPStandardLevel2MastoidBeforeRobustDetrendedReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidDetrendedReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2MastoidBeforeDetrendedReports\\dataStatistics.mat', ...
%     'N:\\ARLAnalysis\\VEPNewTrend\\VEPSpecificLevel2AverageDetrendedReports\\dataStatistics.mat'};
% 
%          
% statNames = { ...
%     'collectionStats'; 'collectionStats'; 'collectionStats'; ...
%     'collectionStats'; 'collectionStats'; 'collectionStats'; ...
%     'collectionStats'; 'collectionStats'; 'collectionStats'; ...
%     'collectionStats'; 'collectionStats'; 'collectionStats'; ...
%     'collectionStats'; 'collectionStats'; 'collectionStats'; ...
%      'collectionStats'; 'collectionStats'; 'collectionStats' ...
%      };
%           
%  legendString = { ...
%      'LK M-Robust', 'LK M-Average', 'LK M-Before', ...
%      'VEP Robust', 'VEP M-Robust', 'VEP Mastoid', ...
%      'VEP M-Before', 'VEP Average', 'VEP M-Average', 'VEP original', ...
%      'VEP robust', 'VEP d-robust', 'VEP d-robust-0.5', ...
%      'VEP md-robust', 'VEP d-mastoid', 'VEP md-before', 'VEP d-average' ...
%      };

originalIndices = {7};
%% Read the collectionStats files
collections = cell(length(statFiles), 1);
for k = 1:length(collections)
    fprintf('%d: %s\n', k, statFiles{k});
    x = load(statFiles{k});
    collections{k} = x.(statNames{k});
end
s = collections{1}.statisticsIndex;

%% Calculate the window ref sdr/med window channel deviations
refRatiosDev = cell(length(collections), 1);
for k = 1:length(collections)
    refRatiosDev{k} = collections{k}.statistics(:, s.rSDWinDevRef)./ ...
        collections{k}.statistics(:, s.medWinDevRef);
end;

%% Find the total number of points
titles = legendString;
totalPoints = 0;
data = refRatiosDev;
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
baseTitle = 'Window sdr/med ratio channel deviations';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
h = boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on');
xlabel('SDR/Median window channel deviation')

%% Calculate the window ref sdr/med window channel HF
refRatios = cell(length(collections) + length(originalIndices), 1);
for k = 1:length(collections)
    refRatios{k} = collections{k}.statistics(:, s.rSDWinHFRef)./ ...
        collections{k}.statistics(:, s.medWinHFRef);
end;

baseLength = length(collections);
for k = 1:length(originalIndices)
    refRatios{k + baseLength} = ...
        collections{originalIndices{k}}.statistics(:, s.rSDWinHFOrig)./ ...
        collections{originalIndices{k}}.statistics(:, s.medWinHFOrig);
end

%% Find the total number of points
titles = legendString;
totalPoints = 0;
data = refRatios;
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
baseTitle = 'Window sdr/med ratio channel HF scores';
figure('Name', baseTitle, 'Color', [1, 1, 1]);
h = boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on');
xlabel('SDR/Median window HF scores')

%% Plot before and after mean max correlation
refCorr = cell(length(collections) + length(originalIndices), 1);
for k = 1:length(collections)
    refCorr{k} = collections{k}.statistics(:, s.aveCorRef);
end;

baseLength = length(collections);
for k = 1:length(originalIndices)
    refCorr{k + baseLength} = ...
        collections{originalIndices{k}}.statistics(:, s.aveCorOrig);
end

%% Find the total number of points
titles = legendString;
totalPoints = 0;
data = refCorr;
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
h = boxplot(dataPoints, dataGroups, 'labels', titles, ...
    'orientation', 'horizontal', 'notch', 'on');
xlabel('Mean max correlation')
% refCorr = cell(length(collections), 1);
% origCorr = cell(length(collections), 1);
% minCorr = 1;
% for k = 1:length(collections)
%     refCorr{k} = collections{k}.statistics(datasetMask, s.aveCorRef);
%     origCorr{k} = collections{originalIndex}.statistics(datasetMask, s.aveCorOrig);
%     minCorr = min(minCorr, min(refCorr{k}));
%     minCorr = min(minCorr, min(origCorr{k}));
% end
% baseTitle = 'Mean max window correlation';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% for k = 1:length(collections)
%   plot(origCorr{k}, refCorr{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), ...
%       'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
% end
% for k = 1:length(collections)
%         plot(mean(origCorr{k}), mean(refCorr{k}), 'Marker', markerShapes{k}, ...
%      'MarkerSize', bigMarkerSize, 'LineWidth', medianMarkWidth, ...
%      'MarkerEdgeColor', medianMarkColor,  'MarkerFaceColor', 'none');
% end
% xg = xlabel(originalLabel);
% yg = ylabel('Referenced/Interpolated');
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% box on
% legend(legendString, 'Location', 'NorthWest')
% hold off
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% minLim = min(min(xLim), min(yLim));
% h = line([minLim; 1], [minLim; 1], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Comparison of first to rest of the  mean max correlation
% baseTitle = 'Mean max window correlation';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% for k = restIndices
%   plot(refCorr{comparisonIndex}, refCorr{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), ...
%       'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
% end
% for k = restIndices
%         plot(mean(refCorr{comparisonIndex}), mean(refCorr{k}), 'Marker', markerShapes{k}, ...
%      'MarkerSize', bigMarkerSize, 'LineWidth', medianMarkWidth, ...
%      'MarkerEdgeColor', medianMarkColor, 'MarkerFaceColor', 'none');
% end
% 
% xg = xlabel(legendString{comparisonIndex});
% yg = ylabel('Other versions');
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% legend(legendString(otherLegends), 'Location', 'SouthEast')
% box on
% hold off
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% minLim = min(min(xLim), min(yLim));
% h = line([minLim; 1], [minLim; 1], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Plot before and after median max correlation
% refMedCorr = cell(length(collections), 1);
% origMedCorr = cell(length(collections), 1);
% minMedCorr = 1;
% for k = 1:length(collections)
%     refMedCorr{k} = collections{k}.statistics(datasetMask, s.medCorRef);
%     origMedCorr{k} = collections{originalIndex}.statistics(datasetMask, s.medCorOrig);
%     minMedCorr = min(minMedCorr, min(refMedCorr{k}));
%     minMedCorr = min(minMedCorr, min(origMedCorr{k}));
% end
% baseTitle = 'Median max window correlation';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% 
% for k = 1:length(collections)
%   plot(origMedCorr{k}, refMedCorr{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), ...
%       'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
% end
% for k = 1:length(collections)
%         plot(median(origMedCorr{k}), median(refMedCorr{k}), 'Marker', markerShapes{k}, ...
%      'MarkerSize',  bigMarkerSize, 'LineWidth', medianMarkWidth, ...
%      'MarkerEdgeColor', medianMarkColor, 'MarkerFaceColor', 'none');
% end
% xg = xlabel(originalLabel);
% yg = ylabel('Referenced/Interpolated');
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% legend(legendString, 'Location', 'SouthEast')
% box on
% hold off
% 
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% minLim = min(min(xLim), min(yLim));
% h = line([minLim; 1], [minLim; 1], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Plot comparison of first to others of median max correlation
% baseTitle = 'Median max window correlation';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% 
% for k = restIndices
%   plot(refMedCorr{comparisonIndex}, refMedCorr{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), ...
%       'MarkerFaceColor', markerColors(k, :), 'LineStyle', 'none');
% end
% for k = restIndices
%         plot(median(refMedCorr{comparisonIndex}), median(refMedCorr{k}), 'Marker', markerShapes{k}, ...
%      'MarkerSize',  bigMarkerSize, 'LineWidth', medianMarkWidth, ...
%      'MarkerEdgeColor', medianMarkColor, 'MarkerFaceColor', 'none');
% end
% legend(legendString(otherLegends), 'Location', 'SouthEast')
% xg = xlabel(legendString{comparisonIndex});
% yg = ylabel('Other versions');
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% box on
% hold off
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% minLim = min(min(xLim), min(yLim));
% h = line([minLim; 1], [minLim; 1], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Plot ratios ref sdr/med versus orig sdr/med median channel HF noise
% ref2Ratios = cell(length(collections), 1);
% orig2Ratios = cell(length(collections), 1);
% for k = 1:length(collections)
%     ref2Ratios{k} = collections{k}.statistics(datasetMask, s.rSDWinHFRef)./ ...
%         collections{k}.statistics(datasetMask, s.medWinHFRef);
%     orig2Ratios{k} = collections{originalIndex}.statistics(datasetMask, s.rSDWinHFOrig)./ ...
%         collections{originalIndex}.statistics(datasetMask, s.medWinHFOrig);
% end
% baseTitle = 'Reference ratio sdr/med versus orig ratio sdr/med HF noise';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% for k = 1:length(collections)
%   plot(orig2Ratios{k}, ref2Ratios{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
%       'LineStyle', 'none');
% end
% 
% for k = 1:length(collections)
%    plot( median(orig2Ratios{k}), median(ref2Ratios{k}),...
%     'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, ...
%     'LineWidth', medianMarkWidth, ...
%     'MarkerEdgeColor', medianMarkColor, 'MarkerFaceColor', 'none');
% end
% yg = ylabel('Referenced/Interpolated');
% xg = xlabel(originalLabel);
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% legend(legendString, 'Location', 'NorthWest')
% box on
% hold off
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(xLim(2), yLim(2));
% minLim = min(xLim(1), yLim(1));
% h = line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Plot comparison of selected to rest of  med/sdr window deviation
% baseTitle = 'Ratio sdr/med HF noise';
% figure ('Name', baseTitle, 'Color', [1, 1, 1]);
% hold on
% for k = restIndices
%   plot(ref2Ratios{comparisonIndex}, ref2Ratios{k}, 'Marker', markerShapes{k}, ...
%       'MarkerSize', markerSizes(k), 'MarkerFaceColor', markerColors(k, :), ...
%       'LineStyle', 'none');
% end
% 
% for k = restIndices
%    plot( median(ref2Ratios{comparisonIndex}), median(ref2Ratios{k}),...
%     'Marker', markerShapes{k}, 'MarkerSize', bigMarkerSize, ...
%     'LineWidth', medianMarkWidth, ...
%     'MarkerEdgeColor', medianMarkColor, 'MarkerFaceColor', 'none');
% end
% xg = xlabel(legendString{comparisonIndex});
% yg = ylabel('Other versions');
% set(xg, 'FontWeight', 'Bold', 'FontSize', 12);
% set(yg, 'FontWeight', 'Bold', 'FontSize', 12);
% legend(legendString(otherLegends), 'Location', 'NorthWest')
% box on
% hold off
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% h = line([minLim; maxLim], [minLim; maxLim], [-1, -1], 'LineWidth', 3, ...
%     'Color', divideColor);
% xLim = get(gca, 'XLim');
% yLim = get(gca, 'YLim');
% maxLim = max(max(xLim), max(yLim));
% minLim = min(min(xLim), min(yLim));
% set(h, 'XData', [minLim, maxLim], 'YData', [minLim, maxLim])
% 
% %% Output statistics
% fprintf('\nRatio of referenced to original median window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(medRatios{k}), median(medRatios{k}), ...
%         max(medRatios{k}), min(medRatios{k}), range(medRatios{k}));
% end
% 
% fprintf('\nRatio of referenced to original sdr window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(sdrRatios{k}), median(sdrRatios{k}), ...
%         max(sdrRatios{k}), min(sdrRatios{k}), range(sdrRatios{k}));
% end
% 
% fprintf('\nMedian referenced window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(meds{k}), median(meds{k}), ...
%         max(meds{k}), min(meds{k}), range(meds{k}));
% end
% fprintf('Original median window channel deviations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(meds{k}), median(meds{k}), ...
%         max(meds{k}), min(meds{k}), range(meds{k}));
% 
% fprintf('\nSDR referenced window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(sdrs{k}), median(sdrs{k}), ...
%         max(sdrs{k}), min(sdrs{k}), range(sdrs{k}));
% end
% fprintf('Original sdrs window channel deviations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(sdrs{k}), median(sdrs{k}), ...
%         max(sdrs{k}), min(sdrs{k}), range(sdrs{k}));
% 
% fprintf('\n Referenced med/sdr ratio window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(refRatios{k}), median(refRatios{k}), ...
%         max(refRatios{k}), min(refRatios{k}), range(refRatios{k}));
% end
% fprintf('Original med/sdr ratio window channel deviations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(origRatios{k}), median(origRatios{k}), ...
%         max(origRatios{k}), min(origRatios{k}), range(origRatios{k}));
%     
% fprintf('\n Referenced sdr/med ratio window channel deviations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(ref1Ratios{k}), median(ref1Ratios{k}), ...
%         max(ref1Ratios{k}), min(ref1Ratios{k}), range(ref1Ratios{k}));
% end
% fprintf('Original sdr/med ratio window channel deviations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(orig1Ratios{k}), median(orig1Ratios{k}), ...
%         max(orig1Ratios{k}), min(orig1Ratios{k}), range(orig1Ratios{k}));
%     
% fprintf('\n Referenced mean window channel correlations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(refCorr{k}), median(refCorr{k}), ...
%         max(refCorr{k}), min(refCorr{k}), range(refCorr{k}));
% end
% fprintf('Original mean window channel correlations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(origCorr{k}), median(origCorr{k}), ...
%         max(origCorr{k}), min(origCorr{k}), range(origCorr{k}));
%     
% fprintf('\n Referenced median window channel correlations\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(refMedCorr{k}), median(refMedCorr{k}), ...
%         max(refMedCorr{k}), min(refMedCorr{k}), range(refMedCorr{k}));
% end
% fprintf('Original median window channel correlations\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(origMedCorr{k}), median(origMedCorr{k}), ...
%         max(origMedCorr{k}), min(origMedCorr{k}), range(origMedCorr{k}));
%     
% fprintf('\n Referenced sdr/med ratio window noisiness\n')
% for k = 1:length(collections)
%     fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(ref2Ratios{k}), median(ref2Ratios{k}), ...
%         max(ref2Ratios{k}), min(ref2Ratios{k}), range(ref2Ratios{k}));
% end
% fprintf('Original sdr/med ratio window noisiness\n')
% k = originalIndex;
% fprintf('%d [%s]: mean: %g   median: %g   max: %g  min: %g range: %g\n', k, ...
%         legendString{k}, mean(orig2Ratios{k}), median(orig2Ratios{k}), ...
%         max(orig2Ratios{k}), min(orig2Ratios{k}), range(orig2Ratios{k}));