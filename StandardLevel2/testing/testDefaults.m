%% Test the defaults for resampling

%% No errors
defaults  = getPipelineDefaults([], 'resample');
[structOut1, errors1] = checkDefaults(struct(), struct(), defaults);

%% Default frequency is 256
[structOut2, errors2] = checkDefaults( ...
                     struct('resampleFrequency', 256), struct(), defaults);

%% Default frequency is bad string
[structOut3, errors3] = checkDefaults( ...
                     struct('resampleFrequency', 'abc'), struct(), defaults);
params.resampleFrequency = -3;
[EEG1, resampleOut1] = resampleEEG(EEG, params);
%%
params.resampleFrequency = 256;
[EEG2, resampleOut2] = resampleEEG(EEG, params);

%% Test detrend
defaults  = getPipelineDefaults(EEG, 'detrend');
[structOut1, errors1] = checkDefaults(struct(), struct(), defaults);
%%
params.detrendCutoff = 0;
defaults  = getPipelineDefaults(EEG, 'detrend');
[structOut2, errors2] = checkDefaults(params, struct(), defaults);

%% Test high pass 
detrendIn.detrendType = 'high pass';
[EEG2, detrendOut] = removeTrend(EEG, detrendIn);

%% Test detrend
detrendIn.detrendType = 'linear';
[EEG3, detrendOut1] = removeTrend(EEG, detrendIn);

%% Test line noise
defaultsLine  = getPipelineDefaults(EEG, 'line noise');
[EEG3, lineNoiseOut1] = cleanLineNoise(EEG);


%% Test line noise
defaultsNoisy  = getPipelineDefaults(EEG, 'find noisy');
%[EEG3, lineNoiseOut1] = cleanLineNoise(EEG);

%% Test robust reference
defaults = getPipelineDefaults(EEG, 'robust reference');
referenceIn = struct();
referenceOut = struct();
[referenceOut, errors] = checkDefaults(referenceIn, referenceOut, defaults);