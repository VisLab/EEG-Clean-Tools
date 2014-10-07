function [EEG, referenceSignal, reReferencedChannels] = ...
    removeReference(EEG, referenceSignal, reReferencedChannels)
% Remove the referenceSignal from an EEGLAB EEG structure
%
% EEG = removeReference(EEG)
% EEG = removeReference(EEG, referenceSignal)
% EEG = removeReference(EEG, referenceSignal, reReferencedreReferencedChannels)
%
% Input:
%   EEG              EEGLAB EEG structure (requires .data field) C x N
%   referenceSignal  1 x N vector of reference values to remove from 
%                    EEG reReferencedChannels (default is the column mean 
%                    of EEG reReferencedChannels)
%   reReferencedChannels   vector of row numbers corresponding to channels
%                    from which to remove reference
%                    (default is to use all reReferencedChannels)
%
% Output:
%   EEG                   revised EEG structure
%   referenceSignal       Actual reference that was removed
%   reReferencedChannels  Channels from which the signal was removed
%
% The rereferencedChannel rows of EEG.data have the referenceSignal subtracted. 
%

% Check the arguments
if nargin < 1 || ~isstruct(EEG)
    error('removeReference:NotEnoughArguments', 'first argument must be a structure');
elseif ~exist('reReferenceChannels', 'var') || isempty(reReferenceChannels)
    reReferenceChannels = 1:size(EEG.data, 1); 
end

data = EEG.data(reReferenceChannels, :);
if ~exist('referenceSignal', 'var') || isempty(referenceSignal)
    referenceSignal = mean(data, 1);
end

% Remove the reference
data = bsxfun(@minus, data, referenceSignal);
EEG.data(reReferenceChannels, :) = data;


