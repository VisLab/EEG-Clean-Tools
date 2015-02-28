function [EEG, referenceSignal, rereferencedChannels] = ...
    removeReference(EEG, referenceSignal, rereferencedChannels)
% Remove the referenceSignal from an EEGLAB EEG structure
%
% EEG = removeReference(EEG)
% EEG = removeReference(EEG, referenceSignal)
% EEG = removeReference(EEG, referenceSignal, rereferencedChannels)
%
% Input:
%   EEG              EEGLAB EEG structure (requires .data field) C x N
%   referenceSignal  1 x N vector of reference values to remove from 
%                    EEG rereferencedChannels (default is the column mean 
%                    of EEG reReferencedChannels)
%   rereferencedChannels   vector of row numbers corresponding to channels
%                    from which to remove reference
%                    (default is to use all rereferencedChannels)
%
% Output:
%   EEG                     revised EEG structure
%   referenceSignal         Actual reference that was removed
%   rereferencedChannels    Channels from which the signal was removed
%
% The rereferencedChannels rows of EEG.data have the referenceSignal subtracted. 
%

% Check the arguments
if nargin < 1 || ~isstruct(EEG)
    error('removeReference:NotEnoughArguments', 'first argument must be a structure');
elseif ~exist('rereferencedChannels', 'var') || isempty(rereferencedChannels)
    rereferencedChannels = 1:size(EEG.data, 1); 
end

data = EEG.data(rereferencedChannels, :);
if ~exist('referenceSignal', 'var') || isempty(referenceSignal)
    referenceSignal = mean(data, 1);
end

% Remove the reference
data = bsxfun(@minus, data, referenceSignal);
EEG.data(rereferencedChannels, :) = data;


