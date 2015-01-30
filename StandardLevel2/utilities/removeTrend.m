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
%   detrendCutoff     Detrend or high pass cutoff (default is 0.2 Hz)
%
% Output:
%   EEG               Revised EEG structure channels detrended or filtered
%   detrendOut        Structure with the following items described below:
% 
% Structure parameters (detrendOut):
%   detrendChannels   Vector of detrended or filtered channels 
%   detrendType       Type of detrending or filtering
%   detrendCutoff     High pass cutoff (default is 1 Hz)
%   detrendCommand    String version of detrending command
%
% Implementation notes:
%   1) High pass filtering is done with EEGLAB pop_eegfiltnew FIR filter
%   2) Detrending is done with the chronux_2 runline command
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

detrendOut = struct('detrendChannels', [], 'detrendType', [], ...
                    'detrendCutoff', [], 'detrendCommand', []);
detrendOut.detrendChannels =  ...
    getStructureParameters(detrendIn, 'detrendChannels', 1:size(EEG.data, 1));
detrendOut.detrendCutoff =  ...
    getStructureParameters(detrendIn, 'detrendCutoff', 0.2);
detrendOut.detrendType = ...
    getStructureParameters(detrendIn, 'detrendType', 'linear');
%% Detrend the data
EEG.data = double(EEG.data);
if strcmpi(detrendOut.detrendType, 'none')
    detrendOut.detrendCommand = '';
elseif strcmpi(detrendOut.detrendType, 'high pass')
    EEG1 = EEG;
    EEG1.data = EEG.data(detrendOut.detrendChannels, :);
    [EEG1, detrendOut.detrendCommand] = ...
        pop_eegfiltnew(EEG1, detrendOut.detrendCutoff, []);
    
    EEG.data(detrendOut.detrendChannels, :) = EEG1.data;
else
    windowSize = 0.25./detrendOut.detrendCutoff;
    stepSize = windowSize./5;
    EEG.data(detrendOut.detrendChannels, :) = ...
        localDetrend(EEG.data(detrendOut.detrendChannels, :)', ...
                            EEG.srate, windowSize, stepSize)';
    detrendOut.detrendCommand = ['localDetrend(data, ' ...
        num2str(EEG.srate) ', ' num2str(windowSize) ', ' ...
        num2str(stepSize) ')'];
end

