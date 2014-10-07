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

%% Part III: Remove a robust reference
fprintf('\nRobust reference removal\n');
tic
reference = struct('srate', EEG.srate, ...
    'referenceChannels', referenceChannels, ...
    'reReferencedChannels', reReferencedChannels, ...
    'channelLocations', EEG.chanlocs, 'channelInformation', EEG.chaninfo);
[EEG, EEG.etc.noisyParameters.reference] = robustReference(EEG, reference);
computationTimes.reference = toc;

