%% Load the statistics and extract summaries from the data for compendium
%% 
statisticsTitles = {'original'; 'mastoid'; 'average'; 'robustOriginal'; ...
                    'robustBeforeInterpolation'; 'robustFinal'};
summaryNames = {'Mean max correlation'; ...
                'Median max correlation'; ...
                'Median channel deviation'; ...
                'SDR channel deviation'};
statisticsFiles = {'N:\\ARLAnalysis\\VEP\\VEP_Summary.mat'; ...
                   'N:\\ARLAnalysis\\NCTU\\NCTU_Summary.mat'; ....
                   'N:\\ARLAnalysis\\Shooter\\Shooter_Summary.mat'; ...
                   'N:\\BCI2000\\BCI2000_Summary.mat'};

summaries = cell(length(statisticsFiles), 1);
%% Extract the sample statistics
for k = 1:length(statisticsFiles)
    load(statisticsFiles{k}, '-mat');
    stats = NaN(length(noisyStatistics), length(summaryNames), ...
        length(statisticsTitles));
    for n = 1:length(noisyStatistics)
        for j = 1:length(statisticsTitles)
            x = noisyStatistics(n).(statisticsTitles{j});
            if ~isempty(x)
                devs = x.channelDeviations;
                corrs = x.maximumCorrelations;
                evalChannels = x.evaluationChannels;
                devs = devs(evalChannels, :);
                corrs = corrs(evalChannels, :);
                stats(n, 1, j) = mean(corrs(:));
                stats(n, 2, j) = median(corrs(:));
                stats(n, 3, j) = median(devs(:));
                stats(n, 4, j) = mad(devs(:), 1)*1.4826;
            end
        end
    end
    summaries{k} = stats;
end

%% 
compositeSummary = struct('titles', [], 'names', [], ...
    'files', [], 'summaries', []);

compositeSummary.titles = statisticsTitles;
compositeSummary.names = summaryNames;
compositeSummary.files = statisticsFiles;
compositeSummary.summaries = summaries;
 
%%
save('compositeSummary.mat', 'compositeSummary', '-v7.3');
