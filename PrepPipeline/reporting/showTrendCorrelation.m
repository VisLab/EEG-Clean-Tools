function showTrendCorrelation(fitVals, correlations, titleString)

figure('Name', titleString, 'Color', [1, 1, 1]);
hold on
line([-1, 1], [0, 0], 'LineWidth', 2', 'Color', [0.9, 0.9, 0.9])
plot(correlations, fitVals(:, 1), 'k', 'Marker', '+', 'MarkerSize', 12', ...
    'LineWidth', 2, 'LineStyle', 'None')
hold off
set(gca, 'XLim', [-1, 1], 'XLimMode', 'manual')
xlabel('Channel-trend correlation')
ylabel('Slope of trend')
title(titleString, 'Interpreter', 'none')

figure('Name', titleString, 'Color', [1, 1, 1]);
hold on
line( [0, 0], [-1, 1], 'LineWidth', 2', 'Color', [0.9, 0.9, 0.9])
plot(fitVals(:, 1), correlations, 'k', 'Marker', '+', 'MarkerSize', 12', ...
    'LineWidth', 2, 'LineStyle', 'None')
hold off
set(gca, 'YLim', [-1, 1], 'YLimMode', 'manual')
ylabel('Channel-trend correlation')
xlabel('Slope of trend')
title(titleString, 'Interpreter', 'none')