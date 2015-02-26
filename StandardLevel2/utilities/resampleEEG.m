function [EEG, resampleOut] = resampleEEG(EEG, resampleIn)
% Perform a resampling using EEGLAB pop_resample -- specific to EEGLAB EEG
%
% Usage:
%   EEG = resample(EEG)
%   [EEG, resampleOut] = resampleEEG(EEG, resampleIn)
%
% Input:
%   EEG                 Structure that requires .data and .srate fields 
%   resampleIn          Input structure with fields described below
% 
% Structure parameters (resampleIn):
%   resampleFrequency   Frequency to resample at (default is 512 Hz)
%
% Output:
%   EEG                 Revised EEG structure with channels resampled
%   resampleOut         Structure with the following items described below
% 
% Structure parameters (resampleOut):
%   resampleFrequency   Frequency to resample at (default is 512 Hz)
%   originalFrequency   Original frequency of the data
%
%% Check the parameters
if nargin < 1 || ~isstruct(EEG)
    error('resampleEEG:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2
    resampleIn = struct();
end
defaults = getPipelineDefaults(EEG, 'resample');
resampleOut = struct('resampleFrequency', [], 'originalFrequency', EEG.srate);
[resampleOut, errors] = checkDefaults(resampleIn, resampleOut, defaults);
if ~isempty(errors)
    error('resampleEEG:BadParameters', ['|' sprintf('%s|', errors{:})]);
end

%% Resample the EEG data
if resampleOut.originalFrequency <= resampleOut.resampleFrequency  
    resampleOut.resampleFrequency = EEG.srate;
else
    EEG = pop_resample(EEG, resampleOut.resampleFrequency);
end
