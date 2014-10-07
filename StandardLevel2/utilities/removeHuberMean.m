function [EEG, huberMean, referenceChannels] = removeHuberMean(EEG, referenceChannels, iterations)
% Remove the Huber robust mean from referenceChannels in an EEGLAB EEG structure
%
% EEG = removeRobustMean(EEG)
% EEG = removeRobustMean(EEG, referenceChannels)
% [EEG, robustMean, referenceChannels] = removeRobustMean(EEG, referenceChannels, iterations)
%
% Input:
%   EEG               EEGLAB EEG structure
%   referenceChannels   vector of EEG channel numbers for which to remove mean
%                     (default is to use all referenceChannels)
%   iterations        Number of iterations to use in the huber mean calculation
%                     (default is 100 iterations)
%
% Output:
%   EEG                Revised EEG structure
%   robustMean         Robust mean that was removed
%   referenceChannels  Actual reference channels used
%
% This function calculates a robust channel mean based on the channel
% numbers in referenceChannels and subtracts this mean from the data corresponding
% to these referenceChannels. The function also stores the referenceChannels and the 
% calculated average reference in EEG.etc.
%
% Adapted from code by Christian Kothe
%
%% Process the arguments
if nargin < 1 || ~isstruct(EEG)
    error('removeHuberMean:NotEnoughArguments', ...
          'first argument must be a structure');
elseif ~exist('referenceChannels', 'var') || isempty(referenceChannels)
    referenceChannels = 1:size(EEG.data, 1); 
end

if ~exist('iterations', 'var') || isempty(iterations)
    iterations = 100; 
end

% Remove the robust mean and create an reference signal
data = EEG.data(referenceChannels, :);
huberCut = median(median(abs(bsxfun(@minus, data, median(data, 2))),2))*1.4826;
huberMean = calculateHuberMean(data/huberCut, 1, iterations)*huberCut;
EEG.data(referenceChannels, :) = ...
        bsxfun(@minus, EEG.data(referenceChannels, :), huberMean);

