%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
params = struct();
%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.evaluationChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;
%% Specific setup
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
params.referenceType = 'robust';
basenameOut = [basename 'HPRev_cutoff' num2str(params.detrendCutoff)];
% %%
% outdir = 'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2Test';
% fname = [indir filesep 'vep_01.set'];
% EEG = pop_loadset(fname);
% %% Part I: Resampling
% fprintf('Resampling\n');
% try
%     tic
%     [EEG, resampling] = resampleEEG(EEG, params);
%     EEG.etc.noiseDetection.resampling = resampling;
%     computationTimes.resampling = toc;
% catch mex
%     errorMessages.resampling = ...
%         ['standardLevel2Pipeline failed resampleEEG: ' getReport(mex)];
%     errorMessages.status = 'unprocessed';
%     EEG.etc.noiseDetection.errors = errorMessages;
%     return;
% end
% 
% %% Part III: Remove line noise
% fprintf('Line noise removal\n');
% try
%     tic
%     [EEG, lineNoise] = cleanLineNoise(EEG, params);
%     EEG.etc.noiseDetection.lineNoise = lineNoise;
%     computationTimes.lineNoise = toc;
% catch mex
%     errorMessages.lineNoise = ...
%         ['standardLevel2Pipeline failed cleanLineNoise: ' getReport(mex)];
%     errorMessages.status = 'unprocessed';
%     EEG.etc.noiseDetection.errors = errorMessages;
%     return;
% end 
% save('EEGtemp.mat', 'EEG', '-v7.3');

%% Load line noise removed 
load EEGtemp.mat;
EEG2 = EEG;
% %% High pass channels 
% fprintf('Detrending\n');
% try
%     tic
%     [EEG, detrend] = removeTrend(EEG, params);
%     EEG.etc.noiseDetection.detrend = detrend;
%     computationTimes.detrend = toc;
% catch mex
%     errors = ['findReference failed removeTrend: ' getReport(mex)];
%     return;
% end
% save('EEGtemp1.mat', 'EEG', '-v7.3');

%%
%load EEGtemp1.mat;

%% Run the pipeline
referenceOut = findReference(EEG, params);

%% Part V: Interpolate channels on the original signal
noisyChannels = referenceOut.badChannels;
sourceChannels = setdiff(referenceOut.evaluationChannels, noisyChannels);
if ~isempty(noisyChannels)
   EEGTemp = interpolateChannels(EEG2, noisyChannels, sourceChannels);
   referenceSignal = mean(EEGTemp.data(referenceOut.referenceChannels, :), 1);
else
   referenceSignal = mean(EEG2.data(referenceOut.referenceChannels, :), 1);
end
EEG2 = removeReference(EEG2, referenceSignal, ...
                                 referenceOut.rereferencedChannels);
EEG = EEG2;
save('EEGtemp2.mat', 'EEG','-v7.3');
%% Part VI: Find the noisy channels without HP
noisyOut2 = findNoisyChannels(EEG2, params);

%% Part II: Detrend or high pass filter
fprintf('Detrending\n');
try
    tic
    [EEG3, trend] = removeTrend(EEG2, params);
    EEG.etc.noiseDetection.detrend = trend;
    computationTimes.detrend = toc;
catch mex
    errorMessages.removeTrend = ...
        ['standardLevel2Pipeline failed removeTrend: ' getReport(mex)];
    errorMessages.status = 'unprocessed';
    EEG.etc.noiseDetection.errors = errorMessages;
    return;
end

%%
noisyOut3 = findNoisyChannels(EEG3, params);