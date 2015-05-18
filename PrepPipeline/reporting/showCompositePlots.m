function [] = showCompositePlots(composite)
% Takes a structure with titles, names, files, summaries and plots them.
% compositeSummary = struct('statisticsTitles', [], 'summaryNames', [], ...
%     'statisticsFiles', [], 'summaries', []);
% 
% compositeSummary.statisticsTitles = statisticsTitles;
% compositeSummary.summaryNames = summaryNames;
% compositeSummary.statisticsFiles = statisticsFiles;
% compositeSummary.summaries = summaries;
% 
% %%
% save('compositeSummary.mat', 'compositeSummary', '-v7.3');

%% Plot the summaries
titles = compositeSummary.statisticsFiles;


colors = [0, 0, 1; 0, 1, 0; 0.8, 0.8, 0.8; 0, 0, 0];
symbols = {'o'; 's'; '^'; 'v'};
indices = [1, 2, 3, 6];
titles = {'VEP', 'NCTU', 'Shooter', 'BCI2000'};
%% 
for k = 1:length(titles)
    summary = compositeSummary.summaries{k};
    figure('Color', [1, 1, 1], 'Name', titles{k})
    hold on
    for j = 1:length(indices)
        data = squeeze(summary(:, :, j));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(data(:, 1), data(:, 3), 'Marker', symbols{k}, ...
            'Color', colors(j, :), 'LineStyle', 'none');
    end
    set(gca, 'YLim', [0, 3])
    hold off
    box on
end

%%
for k = 1:length(titles)
    summary = compositeSummary.summaries{k};
    figure('Color', [1, 1, 1], 'Name', titles{k})
    hold on
    for j = 1:length(indices)
        data = squeeze(summary(:, :, j));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(data(:, 2), data(:, 4)./data(:, 3), 'Marker', symbols{k}, ...
            'Color', colors(j, :), 'LineStyle', 'none');
    end
    hold off
    box on
end
% %%
% baseTitle = 'Comparison of channel deviation and correlation';
%     figure ('Name', baseTitle);
%     refRatio = statistics(:, s.rSDWinDevRef)./statistics(:, s.medWinDevRef);
%     origRatio = statistics(:, s.rSDWinDevOrig)./statistics(:, s.medWinDevOrig);
%     hold on
%     plot(statistics(:, s.medCorRef), refRatio, 'ok')
%         plot(median(statistics(:, s.medCorRef)), median(refRatio), ...
%         '+r', 'MarkerSize', 14, 'LineWidth', 3);
%     plot(statistics(:, s.medCorOrig), origRatio, 'sb')
%     plot( median(statistics(:, s.medCorOrig)), median(origRatio), ...
%         'xr', 'MarkerSize', 14, 'LineWidth', 3);
%     xlabel('Median min window correlation');
%     ylabel('SDR/Median ratio');
%     title({collectionTitle; baseTitle; ...
%         ['[Window channel deviations SDR/Median ratios: ' num2str(median(refRatio)) '(ref) ' ...
%         num2str(median(origRatio)) '(orig)]']});
%     legend('Referenced', 'Median referenced', 'Original', 'Median original', ...
%            'Location', 'NorthWest')
%     hold off