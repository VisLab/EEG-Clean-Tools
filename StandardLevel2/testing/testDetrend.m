%% Test linear detrending
t = 1:0.01:1000;
trend = 0.5*t + 8;
data = random('normal', 0, 8, 3, length(t)) + repmat(trend, 3, 1);

%% Test runline directly
t = 1:0.01:1000;
trend = 0.5*t + 8;
data = random('normal', 0, 8, 3, length(t)) + repmat(trend, 3, 1);
z = runline(data(1, :)', 2.5 * 100, 25);

% %% Run sift method
% [dataSift, g, fitlines] = pre_detrend(data, 100);
% 
% 
% %% Run this method
% dataNew = removeLocalTrend(data', 100, 0.33, 0.0825);
% 
% %%
% testVal = sum(sum(abs(dataSift-dataNew')));
% 
% %%
% figure
% plot(data')
% title('Original')
% 
% figure
% plot(dataNew)
% title('Trend removed')
% 
% figure
% plot(dataSift');
% title('Sift version')
% 


