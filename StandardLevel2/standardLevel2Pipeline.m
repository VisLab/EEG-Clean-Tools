%% Standard level 2 pipeline 
% This assumes the following have been set:
%  EEG                       An EEGLAB structure with the data is available
%  referenceChannels         A vector of channels to be used for
%                            rereferencing (Usually these are EEG (no
%                            mastoids or EOG)
%  channelsToBeReferenced    A vector of channels to be high-passed, 
%                            line-noise removed, and referenced. 
%  lineFrequencies           A list of line frequencies
%  thisName                  An identifying dataset name (for plotting)
%  
% Additional setup:
%    EEGLAB should be in the path.
%    The stdlevel2 directory and its subdirectories should be in the path
%

%% Setup
pop_editoptions('option_single', false, 'option_savetwofiles', false);
if isfield(EEG.etc, 'noisyParameters')
    warning('EEG.etc.noisyParameters already exists and will be cleared\n')
end
EEG.etc.noisyParameters = struct('name', thisName, 'version', getStandardLevel2Version);

%% Part I: High pass filter
fprintf('High pass filtering\n');
tic
highPass = struct('highPassChannels',  highPassChannels, ...
                  'highPassCutoff', 1);
[EEG, EEG.etc.noisyParameters.highPass] = highPassFilter(EEG, highPass);
computationTimes.highPass = toc;

%% Part II: Resampling
fprintf('Resampling\n');
tic
originalFrequency = EEG.srate;
resampleFrequency = 512;
if EEG.srate <= resampleFrequency  
    resampleFrequency = EEG.srate;
else
    EEG = pop_resample(EEG, resampleFrequency);
end
EEG.etc.noisyParameters.resampling = ...
             struct('originalFrequency', originalFrequency, ...
                    'resampledFrequency', resampleFrequency);
computationTimes.resampling = toc;

%% Part III: Remove line noise
fprintf('Line noise removal\n');
tic
lineNoise = struct('Fs', EEG.srate, 'lineFrequencies', lineFrequencies, ...
                   'lineNoiseChannels', rereferencedChannels, ...
                   'fPassBand', fPassBand);
[EEG, lineNoise] = cleanLineNoise(EEG, lineNoise); 
EEG.etc.noisyParameters.lineNoise = lineNoise;
computationTimes.lineNoise = toc;
clear lineNoise;
%% Part IV: Remove a robust reference
fprintf('Robust reference removal\n');
tic
reference = struct('srate', EEG.srate, ...
    'referenceChannels', referenceChannels, ...
    'rereferencedChannels', rereferencedChannels, ...
    'channelLocations', EEG.chanlocs, 'channelInformation', EEG.chaninfo);
[EEG, reference] = robustReference(EEG, reference);
EEG.etc.noisyParameters.reference = reference;
clear reference;
computationTimes.reference = toc;

