indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
%outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
basename = 'vep';

pop_editoptions('option_single', false, 'option_savetwofiles', false);
lineFrequencies = [60, 120,  180, 212, 240];
referenceChannels = 1:64;
reReferencedChannels = 1:70;
%% Run the pipeline
k = 3;
thisName = sprintf('%s_%02d', basename, k);
fname = [indir filesep thisName '.set'];
EEG = pop_loadset(fname);

%%
pop_editoptions('option_single', false, 'option_savetwofiles', false);
if isfield(EEG.etc, 'noisyParameters')
    warning('EEG.etc.noisyParameters already exists and will be cleared\n')
end
EEG.etc.noisyParameters = struct('name', thisName, 'version', getStandardLevel2Version);
computationTimes = struct('highPass', 0, 'lineNoise', 0, 'reference', 0);
%% Part I: High pass filter
fprintf('\nHigh pass filtering\n');
tic
highPass = struct('highPassChannels',  1:size(EEG.data, 1), ...
    'highPassCutoff', 1);
[EEG, EEG.etc.noisyParameters.highPass] = highPassFilter(EEG, highPass);
computationTimes.highPass = toc;

%% Part II: Remove line noise
fprintf('\n\nLine noise removal\n');
tic
lineNoise = struct('Fs', EEG.srate, 'lineFrequencies', lineFrequencies, ...
    'lineNoiseChannels', reReferencedChannels);
[EEG, EEG.etc.noisyParameters.lineNoise] = cleanLineNoise(EEG, lineNoise);
computationTimes.lineNoise = toc;

% %% Part III: Remove a robust reference
% fprintf('\nRobust reference removal\n');
% tic
% reference = struct('srate', EEG.srate, ...
%     'referenceChannels', referenceChannels, ...
%     'reReferencedChannels', reReferencedChannels, ...
%     'channelLocations', EEG.chanlocs, 'channelInformation', EEG.chaninfo);
% [EEG, EEG.etc.noisyParameters.reference] = robustReference(EEG, reference);
% computationTimes.reference = toc;

%%
fprintf('Computation times (seconds): %g high pass, %g line noise, %g reference \n', ...
    computationTimes.highPass, computationTimes.lineNoise, ...
    computationTimes.reference);

