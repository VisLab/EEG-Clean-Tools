%% Test filtering
dataset = 'vep_06';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
EEG = pop_loadset('filename', [dataset '.set'],'filepath','E:\\CTAData\\VEP\\');
EEG.data = double(EEG.data);
srate = EEG.srate;
%% Test high pass filtering at 1 Hz
trendCutoff = [0.2, 0.3, 0.5, 1, 1.5] ;
typeSymbols = {'s', '+', '^'};
typeLetters = {'N', 'S', 'T'};
typeNames = {'New', 'Sinc', 'Trend'};
cutValues = {'02', '03', '05', '10', '15'};
EEGFilt = cell(3, length(trendCutoff));
for k = 1:length(trendCutoff)
  EEGFilt{1, k} = pop_eegfiltnew(EEG, trendCutoff(k), []);
  %fOrder = %round(5632/trendCutoff(k));
  fOrder = round(14080*srate/512);
  fOrder = fOrder + mod(fOrder, 2);  % Must be even
  EEGFilt{2, k} = pop_firws(EEG, 'fcutoff', trendCutoff(k), 'ftype', 'highpass', ...
                      'wtype', 'blackman', 'forder', fOrder, 'minphase', 0);
  windowSize = 1.5/trendCutoff(k); 
  stepSize = 0.02; 
  EEGTemp = EEG;
  EEGTemp.data = localDetrend(EEG.data', EEG.srate, windowSize, stepSize)';
  EEGFilt{3, k} = EEGTemp;
end
%% Calculate the correlations
channels = 1:64;
timeIndex = 1:size(EEG.data, 2);
s = size(EEGFilt);
numCases = s(1)*s(2);
corData = zeros(numCases, numCases, length(channels));
for k = 1:numCases
    [k1, k2] = ind2sub(s, k);
    for j = 1:numCases
        [j1, j2] = ind2sub(s, j);
        for c = channels
            corData(k, j, c) = ...
                corr(EEGFilt{k1, k2}.data(c, timeIndex)', ...
                     EEGFilt{j1, j2}.data(c, timeIndex)');
        end
    end
end

%% Show the correlations based on 
corDataMean = mean(corData, 3);

legStrings = cell(1, numCases);
symbols = cell(1, numCases);
for k = 1:numCases
    [k1, k2] = ind2sub(s, k);
    legStrings{k} = [typeLetters{k1} cutValues{k2}];
    symbols{k} = typeSymbols{k1};
end
colors = jet(numCases);
figure
set(gca, 'FontSize', 10)
hold on
for k = 1:numCases
    plot(corDataMean(k, :), ['-' symbols{k}], 'Color', colors(k, :), ...
        'MarkerSize', 8, 'LineWidth', 2);
end
hold off
legend(legStrings, ...
    'Orientation', 'Vertical', 'Location', 'EastOutside')
set(gca, 'XTickMode', 'manual', 'XTick', 1:numCases, ...
    'XLimMode', 'manual', 'XLim', [0, numCases+1], ...
    'XTickLabelMode', 'manual', 'XTickLabel', legStrings);
ylabel('Average signal correlation')
xlabel('Filter category')
title('Comparison of signal correlation of different methods/cutoffs')            


%%  Comparison by cutoff
channel = 5;
tRange = [305,313];
%tRange = [];
t = (0:(size(EEG.data, 2)-1))./EEG.srate;
if isempty(tRange)
    tPts = 1:size(EEG.data, 2);
else
    tPts = find(t >= tRange(1) & t <= tRange(2));
end
t = t(tPts);
titleString = ['Filter comparison: ' dataset ' channel:' ...
    num2str(channel) ' cutoff:'];
colorsFilt = [0, 0, 0; 0, 0.5, 1; 1, 0, 0];

for k = 1:s(2)
   theTitle = [titleString num2str(trendCutoff(k))];
   figure('Name', theTitle)
   hold on
   for j = 1:s(1)
      plot(t, EEGFilt{j, k}.data(channel, tPts), 'Color', colorsFilt(j, :));
   end
   hold off
   title(theTitle, 'Interpreter', 'none')
   xlabel('Seconds')
   ylabel('mV')
   legend(typeLetters)
end

%% 
channel = 5;
tRange = [305,313];
%tRange = [];
t = (0:(size(EEG.data, 2)-1))./EEG.srate;
if isempty(tRange)
    tPts = 1:size(EEG.data, 2);
else
    tPts = find(t >= tRange(1) & t <= tRange(2));
end
t = t(tPts);
colors = jet(length(trendCutoff));
baseTitle = ['Comparison by filter: ' dataset ' channel:' ...
    num2str(channel) ' filter:'];
for j = 1:s(1)
    theTitle = [baseTitle ' ' typeNames{j}]; 
    figure('Name', theTitle)
    hold on
    for k = 1:s(2)
        plot(t, EEGFilt{j, k}.data(channel, tPts), 'Color', colors(k, :));
    end
    hold off
    title(theTitle, 'Interpreter', 'none')
    xlabel('Seconds')
    ylabel('mV')
    legend(cutValues)
end

