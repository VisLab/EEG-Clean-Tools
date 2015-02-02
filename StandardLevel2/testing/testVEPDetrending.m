%% This script tests the difference between detrend and high pass for VEP

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
params = struct();
cutoffs = [0.1, 0.2, 0.5, 1, 2];
params.detrendStepSize = 0.05;
highPassCutoff = 0.2;
%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;

%% Run the pipeline
datasets = 1;
fref = cell(length(datasets), length(cutoffs) + 1);
sref = cell(length(datasets), length(cutoffs) + 1);
badChannels = cell(length(datasets), length(cutoffs) + 1);
EEGNew = cell(length(datasets), length(cutoffs) + 1);
for k = 1:length(datasets)
    thisName = sprintf('%s_%02d', basename, k); 
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    [EEG, resampling] = resampleEEG(EEG, params);
    params.detrendType = 'linear';
    for j = 1:length(cutoffs)  
        fprintf('%d cutoff %g\n', k, cutoffs(j));
        params.detrendCutoff = cutoffs(j);
        basenameOut = [basename '_cutoff' num2str(params.detrendCutoff)];
        params.name = sprintf('%s_%02d', basenameOut, k);
        EEGNew{k, j} = removeTrend(EEG, params);
        [a, b, c] = showSpectrum(EEGNew{k, j}, params.detrendChannels, [], [], []);
        badChannels{k, j} = a;
        fref{k, j} = b;
        sref{k, j} = c;
    end 
    params.detrendType = 'high pass';
    params.detrendCutoff = highPassCutoff;
    EEGNew{k,  length(cutoffs) + 1} = removeTrend(EEG, params);
    [e, f, g] = showSpectrum(EEGNew{k,  length(cutoffs) + 1}, params.detrendChannels, [], [], []);
    badChannels{k, length(cutoffs) + 1} = e;
    fref{k, length(cutoffs) + 1} = f;
    sref{k, length(cutoffs) + 1} = g; 
end

%% Show the spectra
numberPts = 70;
colors = [1, 0, 0; 0.7, 0, 0.7; 0, 1, 1; ...
          0, 1, 0;   0, 0, 0.8; 0, 0, 0];
legends = {'0.1', '0.2', '0.5', '1', '2', ['HP' num2str(highPassCutoff)]};
channels = [1, 5, 8, 10];
for k = 1:length(datasets)
    for n = 1:length(channels)
        chan = channels(n);
        figure
        hold on
        for j = 1:size(sref, 2)
            x = fref{k, j}(chan);
            y = sref{k, j}(chan);
            h = plot(x{1}(1:numberPts), y{1}(1:numberPts), ...
                'Color', colors(j, :), 'LineWidth', 2);
        end
        %set(h, 'LineWidth', '2');
        hold off
        xlabel('Frequency')
        ylabel('Power')
        title(['Detrending: VEP ' num2str(k) ' channel ', num2str(chan)]);
        legend(legends)
    end
end
