function [EEG, highPass] = highPassFilter(EEG, highPass)
% Perform a high-pass filter using EEGLAB FIR filter
%
% EEG = highPassFilter(EEG)
% EEG = highPassFilter(EEG, cutoffHz)
% EEG = highPassFilter(EEG, cutoffHz, filterChannels)
%
% Input:
%   EEG               Structure that requires .data and .srate fields 
%   cutoffHz          High pass cutoff (default is 1 Hz)
%   filterChannels     vector of channels to filter
%
% Output:
%   EEG               Revised EEG structure channels filtered
%   filterCommand     Command used for the actual filtering
%   filterChannels    Actual channels that were filtered
%

%% Check the parameters
if nargin < 1 || ~isstruct(EEG)
    error('highPassFilter:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2
    highPass = struct();
end
highPass =  getStructureParameters(highPass, ...
                                 'highPassChannels',  1:size(EEG.data, 1));
highPass =  getStructureParameters(highPass, 'highPassCutoff', 1);

%% Compute the high pass filter
EEG1 = EEG;
EEG1.data = EEG.data(highPass.highPassChannels, :);
EEG1.chanlocs = EEG.chanlocs(highPass.highPassChannels);
EEG1temp.nbchan = length(EEG1.chanlocs);
[EEG1, highPass.filterCommand] = ...
    pop_eegfiltnew(EEG1, highPass.highPassCutoff, []);
EEG.data(highPass.highPassChannels, :) = EEG1.data;


