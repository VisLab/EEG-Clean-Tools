function [signal, referenceOut] = specificReference(signal, params)
% References with respect to specific reference channels
if nargin < 1
    error('specificReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('specificReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('specificReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('specificReference:NoData', 'signal data must have multiple points');
elseif ~exist('params', 'var') || isempty(params)
    params = struct();
end
if ~isstruct(params)
    error('specificReference:NoData', 'second argument must be a structure')
end
referenceOut = getReferenceStructure();
referenceOut.specificReferenceChannels = sort(getStructureParameters(params, ...
    'specificReferenceChannels',  1:size(signal.data, 1)));
referenceOut.referenceChannels = sort(getStructureParameters(params, ...
    'referenceChannels',  1:size(signal.data, 1)));
referenceOut.rereferencedChannels = sort(getStructureParameters(params, ...
    'rereferencedChannels',  1:size(signal.data, 1)));
referenceOut.channelLocations = getStructureParameters(params, ...
    'channelLocations', signal.chanlocs);
referenceOut.channelInformation = getStructureParameters(params, ...
    'channelInformation', signal.chaninfo);

%% Determine the type of reference
if length(intersect(referenceOut.referenceChannels, ...
          referenceOut.specificReferenceChannels)) == ...
   length(referenceOut.referenceChannels)
   referenceOut.referenceType = 'average';
else
    referenceOut.referenceType = 'specific';
end
%% Find the noisy channels for the initial starting point
referenceOut.noisyOutOriginal = findNoisyChannels(signal, params); 
unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
%% Now remove reference from the signal 
if ~isempty(referenceOut.specificReferenceChannels)
   referenceOut.referenceSignalWithNoisyChannels = ...
      nanmean(signal.data(referenceOut.specificReferenceChannels, :), 1);
else
   referenceOut.referenceSignalWithNoisyChannels = ...
      zeros(1, size(signal.data, 2));
end
signal = removeReference(signal, referenceOut.referenceSignalWithNoisyChannels, ...
                         referenceOut.rereferencedChannels);
                     
%% Interpolate the bad channels
paramsNew = params;
paramsNew.referenceChannels = setdiff(params.referenceChannels, ...
                                      unusableChannels);
noisyOut = findNoisyChannels(signal, paramsNew);

% Potential source channels are those that aren't noisy at all 
noisyChannels = union(noisyOut.noisyChannels, unusableChannels);
sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
referenceOut.interpolatedChannels = noisyChannels;

if length(sourceChannels)  < 2
    error('ordinaryReference:TooManyBad', ...
        'Could not perform a robust reference -- not enough good channels');
elseif ~isempty(referenceOut.interpolatedChannels)  
    signal = interpolateChannels(signal, referenceOut.interpolatedChannels, sourceChannels);
    noisyOut = findNoisyChannels(signal, params); 
end
referenceOut.noisyOut = noisyOut;
referenceOut.interpolatedChannelsFromNaNs = noisyOut.badChannelsFromNaNs;
referenceOut.interpolatedChannelsFromNoData = noisyOut.badChannelsFromNoData;
referenceOut.interpolatedChannelsFromHFNoise = noisyOut.badChannelsFromHFNoise;
referenceOut.interpolatedChannelsFromCorrelation = noisyOut.badChannelsFromCorrelation;
referenceOut.interpolatedChannelsFromDeviation = noisyOut.badChannelsFromDeviation;
referenceOut.interpolatedChannelsFromRansac = noisyOut.badChannelsFromRansac;
referenceOut.interpolatedChannelsFromDropOuts = noisyOut.badChannelsFromDropOuts;
referenceOut.interpolatedChannels = noisyChannels;
noisyOut = findNoisyChannels(signal, params);
referenceOut.channelsStillBad = noisyOut.noisyChannels;
referenceOut.noisyOut = noisyOut;
