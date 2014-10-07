function signal = interpolateChannels(signal, targetChannels, sourceChannels)
% Interpolate the targetChannels rows of signal.data using spherical splines
%
% signal = interpolateChannels(signal, targetChannels)
% [signal, W] = interpolateChannels(signal, targetChannels, sourceChannels)
%
% Input:
%   signal      Structure with data and chanlocs fields compatible with
%               an EEGLAB EEG structure (requires .data and .chanlocs fields)
%   targetChannels  Vector of channel numbers for channels to interpolate (required)
%   sourceChannels  Vector of channel numbers to use in the interpolation
%               (default all channels except destination channels)
%
% Output:
%   signal      Input signal structure with the dest_chans rows of 
%               signal.data replaced with their interpolated values
%
%
% Written by Kay Robbins 8/24/2014 UTSA 
%

%% Check the parameters
if nargin < 1 || ~isstruct(signal) || ~isfield(signal, 'data') || ...
   ~isfield(signal, 'chanlocs')      
    error('interpolateChannels:NotEnoughArguments', ...
          'first argument must be a structure with data and chanlocs fields');
elseif ~exist('targetChannels', 'var') || isempty(targetChannels) || ...
    min(targetChannels) < 0 || max(targetChannels) > size(signal.data, 1)  
    error('interpolateChannels:InterpolatedChannelsOutOfRange', ...
          'interpolated (dest) channels must be in dim 1 of signal.data');
elseif ~exist('sourceChannels', 'var') || isempty(sourceChannels)
    sourceChannels = 1:size(signal.data, 1); 
end
sourceChannels = setdiff(sourceChannels, targetChannels);  % Src and dest not same
if isempty(sourceChannels) || min(sourceChannels) < 0 || max(sourceChannels) > size(signal.data, 1)
    error('interpolateChannels:SourceChannelsOutOfRange', ...
          'source channels must be in dim 1 of signal.data');
end

%% Perform the interpolation -- currently using EEGLAB eeg_interp
sourceChannels = sort(sourceChannels);
targetChannels = sort(targetChannels);
channelsConsidered = union(sourceChannels, targetChannels);
[~, reindexedTargetChannels] = intersect(channelsConsidered, targetChannels);
signaltemp = signal;
signaltemp.data = signal.data(channelsConsidered, :);
signaltemp.chanlocs = signal.chanlocs(channelsConsidered);
signaltemp.nbchan = length(signaltemp.chanlocs);
signaltemp = eeg_interp(signaltemp, reindexedTargetChannels, 'spherical');
reindex = false(1, length(signal.chanlocs));
reindex(targetChannels) = true;
reindex = reindex(channelsConsidered);
signal.data(targetChannels, :) = signaltemp.data(reindex, :);

