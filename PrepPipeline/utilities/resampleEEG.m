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
%   lowPassFrequency    Frequency to low pass filter after resampling
%
% Output:
%   EEG                 Revised EEG structure with channels resampled
%   resampleOut         Structure with the following items described below
% 
% Structure parameters (resampleOut):
%   resampleFrequency   Frequency to resample at (default is 512 Hz)
%   lowPassFrequency    Frequency of low pass or 0 if not performed
%   originalFrequency   Original frequency of the data
%   resampleCommand     Command for resampling
%   lowPassCommand      Command for low pass filtering
%
% This function resamples and also does a low pass filter close to Nyquist
% frequency to avoid aliasing errors.
%
%% Check the parameters
if nargin < 1 || ~isstruct(EEG)
    error('resampleEEG:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2
    resampleIn = struct();
end
defaults = getPrepDefaults(EEG, 'resample');
resampleOut = struct('resampleFrequency', [], ...
                     'lowPassFrequency', [], ...
                     'originalFrequency', EEG.srate, ...
                     'resampleCommand', '', ...
                     'lowPassCommand', '');
[resampleOut, errors] = checkDefaults(resampleIn, resampleOut, defaults);
if ~isempty(errors)
    error('resampleEEG:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
if resampleOut.resampleOff
    return;
end
% pop_editoptions('option_single', false, 'option_savetwofiles', false);

%% Resample the EEG data if the resampling frequency is lower than original
if resampleOut.originalFrequency <= resampleOut.resampleFrequency  
    resampleOut.resampleFrequency = EEG.srate;
    return;
end
EEG.data = double(EEG.data);
[EEG, resampleOut.resampleCommand] = ...
                      pop_resample(EEG, resampleOut.resampleFrequency);
            
%% Low pass filter the EEG to remove
if resampleOut.lowPassFrequency > 0
%        EEG1.data = EEG.data(detrendOut.detrendChannels, :);
%     EEG1.nbchan = size(EEG1.data, 1);
%     [EEG1, detrendOut.detrendCommand] = ...
%         pop_eegfiltnew(EEG1, detrendOut.detrendCutoff, []); 
%     EEG.data(detrendOut.detrendChannels, :) = EEG1.data;
   [EEG, resampleOut.lowPassCommand] = ...            
        pop_eegfiltnew(EEG, [], resampleOut.lowPassFrequency); 
end
