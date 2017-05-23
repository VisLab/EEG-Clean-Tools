function [EEG, globalTrendOut] = removeGlobalTrend(EEG, globalTrendIn) 
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
    error('removeGlobalTrend:NotEnoughArguments', 'first argument must be a structure');
elseif nargin < 2 || ~exist('globalTrendIn', 'var') || isempty(globalTrendIn)
    globalTrendIn = struct();
end
if ~isstruct(globalTrendIn)
    error('removeGlobalTrend:NoData', 'second argument must be a structure')
end

defaults = getPrepDefaults(EEG, 'globaltrend');
globalTrendOut = struct('globalTrendChannels', [], 'doLocal', [], ...
    'localCutoff', [], 'localStepSize', [], 'linearFit', [], ...
     'channelCorrelations', []);
[globalTrendOut, errors] = checkDefaults(globalTrendIn, globalTrendOut, defaults);
if ~isempty(errors)
    error('removeGlobalTrend:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
%% Detrend the data either using high pass or linear detrending
if globalTrendOut.doLocal
    params = struct('detrendChannels', globalTrendOut.globalTrendChannels, ...
                    'detrendType', 'linear', ...
                    'detrendCutoff', globalTrendOut.localCutoff, ...
                    'detrendStepSize', globalTrendOut.localStepSize);
                
    [EEG, trend] = removeTrend(EEG, params);
    globalTrendOut.localTrend = trend;
end

channels = 1:size(EEG.data, 1);
globalTrendOut.globalTrendChannels = channels;
t = 0:(size(EEG.data, 2) - 1);
t = t/EEG.srate;
data = EEG.data(channels, :);
myPval = zeros(size(data, 1), 2);
myCorr = zeros(size(data, 1), 1);
parfor k = 1:size(data, 1)
  myPval(k, :) = polyfit(t, data(k, :), 1);
  myCorr(k) = corr(t', (data(k, :))');
  data(k, :) = data(k, :) - polyval(myPval(k, :), t);
end
globalTrendOut.linearFit = myPval;
globalTrendOut.channelCorrelations = myCorr;
EEG.data(channels, :) = data;