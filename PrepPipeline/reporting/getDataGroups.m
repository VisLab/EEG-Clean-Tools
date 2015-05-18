function [dataGroups, dataPoints] = getDataGroups(collections, fieldPath)
% Helper to extract the groups in a continguous list.
totalPoints = 0;
for k = 1:length(collections)
    totalPoints = totalPoints + length(collections{k}.dataTitles);
end

dataGroups = zeros(totalPoints, 1);
dataPoints = zeros(totalPoints, 1);
startGroup = 1;
for k = 1:length(collections)
    index = getFieldIfExists(collections{k}.statisticsIndex, fieldPath);
    data = collections{k}.statistics(:, index);
    endGroup = startGroup + length(data) - 1;
    dataGroups(startGroup:endGroup) = k;
    dataPoints(startGroup:endGroup) = data(:);
    startGroup = endGroup + 1;
end
end