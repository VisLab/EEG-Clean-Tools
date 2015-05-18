%% Load the statistics and extract summaries from the data for compendium
indir = 'D:\Papers\Current\PreprocessingNewNew\PreprocessingManuscript\Resubmission\Figure8';
load([indir filesep 'compositeSummary.mat']);

%% Plot the summaries
colors = [0, 0, 1; 0, 1, 0; 0.70, 0.70, 0.70; 0, 0, 0];
symbols = {'o'; 's'; '^'; 'v'};
indices = [1, 2, 3, 6];
titles = {'VEP', 'NCTU', 'Shooter', 'BCI2000'};
legendStrings = cell(4, 1);
legendStrings{1} = {'B64-org', 'B64-mas', 'B64-ave', 'B64-rob'};
legendStrings{2} = {'N32-mas', 'N32-ave', 'N32-rob'};
legendStrings{3} = {'N40-mas', 'N40-ave', 'N40-rob'};
legendStrings{4} = {'C64-org', 'C64-ave', 'C64-rob'};
%% 
baseTitle = 'Mean correlation vs Median deviation';
for k = 1:length(titles)
    summary = compositeSummary.summaries{k};
    figure('Color', [1, 1, 1], 'Name', [titles{k} ':' baseTitle])
    hold on
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(data(:, 1), data(:, 3), 'Marker', symbols{k}, ...
            'Color', colors(j, :), 'LineStyle', 'none', ...
            'LineWidth', 2, 'MarkerSize', 12);
    end
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(median(data(:, 1)), median(data(:, 3)), 'Marker', symbols{k}, ...
            'LineStyle', 'none', ...
            'LineWidth', 3, 'MarkerSize', 14, 'MarkerFaceColor', colors(j, :), ...
            'MarkerEdgeColor', [1, 0, 0]);
    end
    hold off
    legend(legendStrings{k}, 'Location', 'NorthWest')
    set(gca, 'XLim', [0.6, 1])
    ylimits = get(gca, 'YLim');
    set(gca, 'YLim', [0, ylimits(2)]);
 
    box on
end

%%
baseTitle = 'Mean correlation vs median(SDR/Median deviation)';
for k = 1:length(titles)
    summary = compositeSummary.summaries{k};
    figure('Color', [1, 1, 1], 'Name', [titles{k} ':' baseTitle])
    hold on
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(data(:, 1), data(:, 4)./data(:, 3), 'Marker', symbols{k}, ...
            'Color', colors(j, :), 'LineStyle', 'none', ...
            'LineWidth', 2, 'MarkerSize', 8);
    end
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(median(data(:, 1)), median(data(:, 4)./data(:, 3)), 'Marker', symbols{k}, ...
            'LineStyle', 'none', ...
            'LineWidth', 3, 'MarkerSize', 12, 'MarkerFaceColor', colors(j, :), ...
            'MarkerEdgeColor', [1, 0, 0]);
    end
    set(gca, 'XLim', [0.6, 1])
    set(gca, 'YLim', [0.0, 0.8])
    hold off
    box on
end

%%
baseTitle = 'Mean correlation vs median deviation ratio';
figure('Color', [1, 1, 1], 'Name', baseTitle)
hold on
for k = length(titles):-1:1
    summary = compositeSummary.summaries{k};
    
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(data(:, 1), data(:, 4)./data(:, 3), 'Marker', symbols{k}, ...
            'Color', colors(j, :), 'LineStyle', 'none', ...
            'LineWidth', 2, 'MarkerSize', 8);
    end
end
for k = length(titles):-1:1
    summary = compositeSummary.summaries{k};
    
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(median(data(:, 1)), median(data(:, 4)./data(:, 3)), 'Marker', symbols{k}, ...
            'LineStyle', 'none', ...
            'LineWidth', 3, 'MarkerSize', 12, 'MarkerFaceColor', colors(j, :), ...
            'MarkerEdgeColor', [1, 0, 0]);
    end
end
set(gca, 'XLim', [0.6, 1])
set(gca, 'YLim', [0.0, 0.8])
hold off
box on

%% Plot the medians.
baseTitle = 'Mean correlation vs median deviation ratio';
figure('Color', [1, 1, 1], 'Name', baseTitle)
hold on
% for k = length(titles):-1:1
%     summary = compositeSummary.summaries{k};
%     
%     for j = 1:length(indices)
%         data = squeeze(summary(:, :, indices(j)));
%         if sum(isnan(data(:))) > 0
%             continue;
%         end
%         plot(data(:, 1), data(:, 4)./data(:, 3), 'Marker', symbols{k}, ...
%             'Color', colors(j, :), 'LineStyle', 'none', ...
%             'LineWidth', 2, 'MarkerSize', 8);
%     end
% end
legendString = {'C64-org', 'C64-ave', 'C64-rob', ...
                'N40-mas', 'N40-ave', 'N40-rob', ...
                'N32-mas', 'N32-ave', 'N32-rob', ...
                'B64-org', 'B64-mas', 'B64-ave', 'B64-rob'};
for k = length(titles):-1:1
    summary = compositeSummary.summaries{k};
    
    for j = 1:length(indices)
        data = squeeze(summary(:, :, indices(j)));
        if sum(isnan(data(:))) > 0
            continue;
        end
        plot(median(data(:, 1)), median(data(:, 4)./data(:, 3)), 'Marker', symbols{k}, ...
            'LineStyle', 'none', ...
            'LineWidth', 3, 'MarkerSize', 12, 'MarkerFaceColor', colors(j, :), ...
            'MarkerEdgeColor', colors(j, :));
    end
end
legend(legendString, 'Location', 'West')
set(gca, 'XLim', [0.6, 1])
set(gca, 'YLim', [0, 0.8])
xlabel('Mean max correlation')
ylabel('Median deviation ratio')
hold off
box on
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