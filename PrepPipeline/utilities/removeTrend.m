function [EEG, detrendOut] = removeTrend(EEG, detrendIn)
% Perform detrending or high pass filtering to remove low frequency
%
% Usage:
%   EEG = removeTrend(EEG)
%   [EEG, detrendOut] = removeTrend(EEG, detrendIn)
%
% Input:
%   EEG               Structure that requires .data and .srate fields 
%   detrendIn         Input structure with fields described below
% 
% Structure parameters (detrendIn):
%   detrendChannels   Vector of channels to detrend or filter 
%                     (default is all channels)
%   detrendType       One of the strings 'high pass', 'linear', or 'none' 
%                     indicating type of detrending (default is'linear')
%   detrendCutoff     Detrend or high pass cutoff (default is 1 Hz)
%   detrendStepSize   Seconds for detrend window slide (default is 0.02 s)
%
% Output:
%   EEG               Revised EEG structure channels detrended or filtered
%   detrendOut        Structure with the following items described below:
% 
% Structure parameters (detrendOut):
%   detrendChannels   Vector of detrended or filtered channels 
%   detrendType       Type of detrending or filtering
%   detrendCutoff     High pass cutoff or detrend window (default is 1 Hz)
%   detrendStepSize   Seconds for detrend window slide (default is 0.02 s)
%   detrendCommand    String version of detrending command
%
% Implementation notes:
%   1) High pass filtering is done with EEGLAB pop_eegfiltnew FIR filter
%   2) Detrending is done with the chronux_2 runline command
%   3) The EEG.data array will be converted to double regardless of type
%
%% Check the parameters
if nargin < 1 || ~isstruct(EEG)
    error('removeTrend:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2 || ~exist('detrendIn', 'var') || isempty(detrendIn)
    detrendIn = struct();
end
if ~isstruct(detrendIn)
    error('removeTrend:NoData', 'second argument must be a structure')
end

defaults = getPrepDefaults(EEG, 'detrend');
detrendOut = struct('detrendChannels', [], 'detrendType', [], ...
                    'detrendCutoff', [], 'detrendStepSize', [], ...
                    'detrendCommand', []);
[detrendOut, errors] = checkDefaults(detrendIn, detrendOut, defaults);
if ~isempty(errors)
    error('removeTrend:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
%% Detrend the data either using high pass or linear detrending
EEG.data = double(EEG.data);
if strcmpi(detrendOut.detrendType, 'none')
    detrendOut.detrendCommand = '';
    return;
end

if strcmpi(detrendOut.detrendType, 'high pass')
    EEG1 = EEG;
    EEG1.data = EEG.data(detrendOut.detrendChannels, :);
    EEG1.nbchan = size(EEG1.data, 1);
    [EEG1, detrendOut.detrendCommand] = ...
        pop_eegfiltnew(EEG1, detrendOut.detrendCutoff, []); 
    EEG.data(detrendOut.detrendChannels, :) = EEG1.data;
elseif strcmpi(detrendOut.detrendType, 'high pass sinc')
    fOrder = round(14080*EEG.srate/512);
    fOrder = fOrder + mod(fOrder, 2);  % Must be even
    EEG1 = EEG;
    EEG1.data = EEG.data(detrendOut.detrendChannels, :);
    EEG1.nbchan = size(EEG1.data, 1);
    [EEG1, detrendOut.detrendCommand] = ...
       pop_firws(EEG1, 'fcutoff', detrendOut.detrendCutoff, 'ftype', 'highpass', ...
       'wtype', 'blackman', 'forder', fOrder, 'minphase', 0);
    EEG.data(detrendOut.detrendChannels, :) = EEG1.data;
else
    windowSize = 1.5/detrendOut.detrendCutoff;
    windowSize = min(windowSize, size(EEG.data, 2));
    stepSize = detrendOut.detrendStepSize; 
    EEG.data(detrendOut.detrendChannels, :) = ...
        localDetrend(EEG.data(detrendOut.detrendChannels, :)', ...
                            EEG.srate, windowSize, stepSize)';
    detrendOut.detrendCommand = ['localDetrend(data, ' ...
        num2str(EEG.srate) ', ' num2str(windowSize) ', ' ...
        num2str(stepSize) ')'];
end