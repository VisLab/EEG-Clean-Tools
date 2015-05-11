function [] = showBadChannelDifferences(noisy1, noisy2)
%% Output the differences in bad channels between two runs
    numberDatasets = length(noisy1);
    for k = 1:numberDatasets
        badChans1 = noisy1(k).badChannelNumbers;
        badChans2 = noisy2(k).badChannelNumbers;
        u = union(badChans1, badChans2);
        inter = intersect(badChans1, badChans2);
        if length(u) ~= length(inter)
            theDiff = setdiff(u, inter);
            fprintf('%d: [%s]\n', k, num2str(theDiff(:)'));
        end  
    end