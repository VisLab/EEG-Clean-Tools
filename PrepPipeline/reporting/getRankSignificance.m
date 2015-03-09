function rankSig = getRankSignificance(statistic, names)
% Use Wilcoxon rank sum test to detect significant differences.
numberCombos = length(statistic)* (length(statistic) - 1)/2;
rankSig(numberCombos) = ...
    struct('first', [], 'second', [], 'p', []);
n = 1;
for k = 1:length(statistic) - 1
    for j = k+1:length(statistic)
        rankSig(n).first = names{k};
        rankSig(n).second = names{j};
        rankSig(n).p = ranksum(statistic{k}, statistic{j});
        n = n + 1;
    end
end