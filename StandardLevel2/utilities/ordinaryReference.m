function [signal, referenceOut] = ordinaryReference(signal, params)

if nargin < 1
    error('ordinaryReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('ordinaryReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('ordinaryReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('ordinaryReference:NoData', 'signal data must have multiple points');
elseif ~exist('params', 'var') || isempty(params)
    params = struct();
end
if ~isstruct(params)
    error('ordinaryReference:NoData', 'second argument must be a structure')
end
referenceOut = struct();
 
referenceOut.referenceChannels = getStructureParameters(params, ...
    'referenceChannels',  1:size(signal.data, 1));
referenceOut.rereferencedChannels =  getStructureParameters(params, ...
    'rereferencedChannels',  1:size(signal.data, 1));
referenceOut.channelLocations = getStructureParameters(params, ...
    'channelLocations', signal.chanlocs);
referenceOut.channelInformation = getStructureParameters(params, ...
    'channelInformation', signal.chaninfo);
referenceOut.interpolateHFChannels = ...
    getStructureParameters(params, 'interpolateHFChannels', false);

%% Find the noisy channels for the initial starting point
referenceOut.averageReferenceWithNoisyChannels = ...
                mean(signal.data(referenceOut.referenceChannels, :), 1);

referenceOut.noisyOutOriginal = findNoisyChannels(signal, params); 

unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
%% Now remove reference from the signal and interpolate bad channels
signal = removeReference(signal, referenceOut.averageReferenceWithNoisyChannels, ...
                         referenceOut.rereferencedChannels);
paramsNew = params;
paramsNew.referenceChannels = setdiff(params.referenceChannels, ...
                                      unusableChannels);
noisyOut = findNoisyChannels(signal, paramsNew);
% Potential source channels are those that aren't noisy at all 
noisyChannels = union(noisyOut.noisyChannels, unusableChannels);
sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);

% Interpolated channels may not be interpolated if failed because of HF
if referenceOut.interpolateHFChannels
    referenceOut.interpolatedChannels = noisyChannels;
    referenceOut.badChannelsNotInterpolated = [];
else % Don't interpolate HF channels
       referenceOut.interpolatedChannels = union(unusableChannels, union( ...
           noisyOut.badChannelsFromDeviation, union( ...
           noisyOut.badChannelsFromCorrelation, ...
           noisyOut.badChannelsFromRansac)));
    referenceOut.badChannelsNotInterpolated = setdiff( ...
        noisyOut.badChannelsFromHFNoise, referenceOut.interpolatedChannels);
end


if length(sourceChannels)  < 2
    error('ordinaryReference:TooManyBad', ...
        'Could not perform a robust reference -- not enough good channels');
elseif ~isempty(referenceOut.interpolatedChannels)  
    signal = interpolateChannels(signal, referenceOut.interpolatedChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, params); 
end
referenceOut.noisyOut = noisyOut;
