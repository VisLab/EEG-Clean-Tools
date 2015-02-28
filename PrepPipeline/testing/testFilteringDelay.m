%% Generate a test set consisting of truncated sine at testFreq
srate = 512;
testFreq = 2;
sampleStep = 1/512;
steps = 50000;
t = (0:(steps-1))/srate;
x = sin(pi*testFreq*t);
xtrunc = [zeros(1, 50000), x];
ttrunc = (0:(length(xtrunc)-1))/srate;
figure
plot(ttrunc, xtrunc)
xlabel('Seconds')

%% Create original EEG data with different amounts of random noise
EEGOrig = cell(1, length(eps));
trials = 100;
eps = [0, 0.01, 0.1, 0.2, 0.5, 1];
nbchan = trials;
for k = 1:length(eps)
    EEG = eeg_emptyset();
    data = zeros(nbchan, length(xtrunc));
    for j = 1:trials
        data(j, :) = xtrunc + random('normal', 0, eps(k), size(xtrunc));
    end
    
    EEG.nbchan = nbchan;
    EEG.data = data;
    EEG.srate = srate;
    EEG.npts = size(data, 2);
    pop_saveset(EEG, 'EEGTemp1.set');
    EEG = pop_loadset('filename','EEGTemp1.set','filepath','D:\\StandardCodeVersioned\\');
    EEGOrig{k} = EEG;
end

%% Filter the data using different methods and different HF cutoffs
trendCutoff = [0.2, 0.3, 0.5, 1, 1.5] ;
methods = {'New', 'Sinc', 'Trend'};
EEGFilt = cell(length(methods), length(trendCutoff), length(eps));
%% Filter using the different methods
for k = 1:length(trendCutoff)
    for j = 1:length(eps)
       EEGFilt{1, k, j} = pop_eegfiltnew(EEGOrig{j}, trendCutoff(k), []);
       fOrder = round(14080*srate/512);
       fOrder = fOrder + mod(fOrder, 2);  % Must be even
       EEGFilt{2, k, j} = pop_firws(EEGOrig{j}, 'fcutoff', trendCutoff(k), 'ftype', 'highpass', ...
                      'wtype', 'blackman', 'forder', fOrder, 'minphase', 0);
       windowSize = 1.5/trendCutoff(k);
       stepSize = 0.02;
       EEGTemp = EEGOrig{j};
       EEGTemp.data = localDetrend(EEGTemp.data', EEG.srate, windowSize, stepSize)';
       EEGFilt{3, k, j} = EEGTemp;
    end
end

%%  Comparison by noise level
typeSymbols = {'s', '+', '^'};
typeLetters = {'N', 'S', 'T'};
typeNames = {'New', 'Sinc', 'Trend'};
cutValues = {'orig' '02', '03', '05', '10', '15'};
filtType = 3;
pointRange = 30;
tRange = (steps - pointRange):(steps + pointRange);
tNew = ttrunc(tRange);
titleString = ['Filter:' typeNames{filtType}  'Dataset: trunc ' ...
    num2str(testFreq) ' Hz   noise:' ];
colorsFilt = [0, 0, 0; 0, 0.5, 1; 1, 0, 0];
colorsCutoff = jet(5);
for k = 1:length(eps)
   theTitle = [titleString num2str(eps(k))];
   figure('Name', theTitle)
   hold on
   data = EEGOrig{k}.data(:, tRange); 
   plot(tNew, mean(data), 'Color', [0.8, 0.8, 0.8], 'LineWidth', 3);
   for j = 1:length(trendCutoff)
      data = EEGFilt{filtType, j, k}.data(:, tRange); 
      plot(tNew, mean(data), 'Color', colorsCutoff(j, :));
   end
   hold off
   title(theTitle, 'Interpreter', 'none')
   xlabel('Seconds')
   ylabel('mV')
   legend(cutValues)
end

%%  Comparison by cutoff
typeSymbols = {'s', '+', '^'};
typeLetters = {'N', 'S', 'T'};
typeNames = {'New', 'Sinc', 'Trend'};
cutValues = {'orig' '02', '03', '05', '10', '15'};
filtType = 3;
pointRange = 30;
tRange = (steps - pointRange):(steps + pointRange);
tNew = ttrunc(tRange);
titleString = ['Dataset: trunc '  num2str(testFreq) ' Hz   noise:' ];
typeNames1 = {'Orig', 'New', 'Sinc', 'Trend'};
colorsFilt = [0, 0, 0; 0, 0.5, 1; 1, 0, 0];
for k = 1:length(eps)
    data = EEGOrig{k}.data(:, tRange);
    for j = 1:length(trendCutoff)
        theTitle = [titleString num2str(eps(k)) ' cutoff: ' num2str(trendCutoff(j))];
        figure('Name', theTitle)
        plot(tNew, mean(data), 'Color', [0.8, 0.8, 0.8], 'LineWidth', 3);
        hold on
        for filtType = 1:length(typeNames)  
            data = EEGFilt{filtType, j, k}.data(:, tRange);
            plot(tNew, mean(data), 'Color', colorsFilt(filtType, :));
        end
        hold off
        title(theTitle, 'Interpreter', 'none')
        xlabel('Seconds')
        ylabel('mV')
        legend(typeNames1)
    end
end