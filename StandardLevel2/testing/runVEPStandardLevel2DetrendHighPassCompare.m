%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'E:\\CTAData\\VEP\'; % Input data directory used for this demo
params = struct();

%% Parameters that must be preset
params.lineFrequencies = [60, 120,  180, 212, 240];
params.referenceChannels = 1:64;
params.rereferencedChannels = 1:70;
params.detrendChannels = 1:70;
params.lineNoiseChannels = 1:70;
params.detrendType = 'linear';
params.detrendCutoff = 0.2;
%% Run the pipeline
k = 1;
thisName = sprintf('%s_%02d', basename, k);
fname = [indir filesep thisName '.set'];
EEG = pop_loadset(fname);
[EEG, resampling] = resampleEEG(EEG, params);

%% Part II: Detrend or high pass filter
fprintf('Detrending\n');
params.detrendType = 'linear';
params.detrendCutoff = 1;
tic
[EEGDetrend1, trend] = removeTrend(EEG, params);
detrendTime1 = toc;

params.detrendType = 'high pass';
params.detrendCutoff = 1;
fprintf('High pass\n');
tic
[EEGHighPass1, highPass] = removeTrend(EEG, params);
highPassTime1 = toc;

params.detrendType = 'linear';
params.detrendCutoff = 0.5;
tic
[EEGDetrendp2, trend] = removeTrend(EEG, params);
detrendTimep2 = toc;

params.detrendType = 'high pass';
params.detrendCutoff = 0.5;
fprintf('High pass\n');
tic
[EEGHighPassp2, highPass] = removeTrend(EEG, params);
highPassTimep2 = toc;

%%
datatrendp2 = EEGDetrendp2.data(1:70, 5000:end-5000);
datahpp2 = EEGHighPassp2.data(1:70, 5000:end-5000);
datatrend1 = EEGDetrend1.data(1:70, 5000:end-5000);
datahp1 = EEGHighPass1.data(1:70, 5000:end-5000);
%%
datacorr_t1_hp1 = zeros(70, 1);
datacorr_t1_hpp2 = zeros(70, 1);
datacorr_t1_tp2 = zeros(70, 1);
datacorr_tp2_hp1 = zeros(70, 1);
datacorr_tp2_hpp2 = zeros(70, 1);
datacorr_hp1_hpp2 = zeros(70, 1);

%%
for k = 1:70
    datacorr_t1_hp1(k) = corr(datatrend1(k, :)', datahp1(k, :)');
    datacorr_t1_hpp2(k) = corr(datatrend1(k, :)', datahpp2(k, :)');
    datacorr_t1_tp2(k) = corr(datatrend1(k, :)', datatrendp2(k, :)');
    datacorr_tp2_hp1(k) = corr(datatrendp2(k, :)', datahp1(k, :)');
    datacorr_tp2_hpp2(k) = corr(datatrendp2(k, :)', datahpp2(k, :)');
    datacorr_hp1_hpp2(k) = corr(datahp1(k, :)', datahpp2(k, :)');
end

%%
mean(datacorr_t1_hp1)
mean(datacorr_t1_hpp2)
mean(datacorr_t1_tp2)
mean(datacorr_tp2_hp1)
mean(datacorr_tp2_hpp2)
mean(datacorr_hp1_hpp2)
%%
j = 1;
figure
plot(datatrend1(j, :)' - datahp1(j, :)')

