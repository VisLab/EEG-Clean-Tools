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
outdir = 'N:\\ARLAnalysis\\VEPTemp\\VEPStandardLevel2Test';
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;
params.referenceType = 'robust';
basenameOut = [basename 'HPRev_cutoff' num2str(params.detrendCutoff)];
%% Run the pipeline
for k = 9%1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    thisNameOut = sprintf('%s_%02d', basenameOut, k);
    params.name = thisNameOut;
    EEG = resampleEEG(EEG, params);
    EEGBefore = cleanLineNoise(EEG, params);
    EEGBeforeFiltered = removeTrend(EEGBefore, params);
    EEGFiltered = removeTrend(EEG, params);
    EEGAfter = cleanLineNoise(EEGFiltered, params);
end

%%
channels = 1:70;
numChans = min(6, length(channels));
indexchans = floor(linspace(1, length(channels), numChans));
displayChannels = channels(indexchans);
channelLabels = {EEG.chanlocs(channels).labels};
[badChannels, fref, sref] = showSpectrum(EEG, channels,  ...
    displayChannels, channelLabels, 'Original' );
[badChannelsBefore, frefBefore, srefBefore] = showSpectrum(EEGBefore, channels, ...
    displayChannels, channelLabels, 'Line noise no filtering' );
[badChannelsBeforeFilt, frefBeforeFilt, srefBeforeFilt] = showSpectrum(EEGBeforeFiltered, channels,  ...
    displayChannels, channelLabels, 'Line noise filtered' );
[badChannelsFiltered, frefFiltered, srefFiltered] = showSpectrum(EEGFiltered, channels, ...
    displayChannels, channelLabels, 'Filtered' );
[badChannelsAfter, frefAfter, srefAfter] = showSpectrum(EEGAfter, channels,  ...
    displayChannels, channelLabels, 'Filtered line noise' );
