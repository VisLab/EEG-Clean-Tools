function [] = showRangeBarChart(titles, data, centers, theXLabel, theTitle)

%% Find the total number of points
totalPoints = 0;
for k = 1:length(titles)
    totalPoints = totalPoints + length(data(k));
end
dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(titles)
    endGroup = startGroup + length(data{k}) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data{k}(:);
end
figure
h = boxplot(dataPoints, dataGroups);
