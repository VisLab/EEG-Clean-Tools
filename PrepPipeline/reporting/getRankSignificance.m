function rankSig = getRankSignificance(dataGroups, dataPoints, dataNames)
% Use Wilcoxon rank sum test to detect significant differences.

numberCombos = length(dataNames)* (length(dataNames) - 1)/2;
rankSig(numberCombos) = ...
    struct('first', [], 'second', [], 'p', []);
n = 1;
for k = 1:length(dataNames) - 1
    for j = k+1:length(dataNames)
        rankSig(n).first = dataNames{k};
        rankSig(n).second = dataNames{j};
        valFirst = dataPoints(dataGroups == k);
        valSecond = dataPoints(dataGroups == j);
        rankSig(n).p = ranksum(valFirst, valSecond);
        n = n + 1;
    end
end