function [signal, referenceOut] = robustReference(signal, params)

if nargin < 1
    error('robustReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('robustReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('robustReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('robustReference:NoData', 'signal data must have multiple points');
elseif ~exist('params', 'var') || isempty(params)
    params = struct();
end
if ~isstruct(params)
    error('robustReference:NoData', 'second argument must be a structure')
end
referenceOut = struct( ...
    'referenceChannels', [], ...
    'rereferencedChannels', [], ...
    'channelLocations', [], ...
    'channelInformation', [], ...
    'maxInterpolationIterations', [], ...
    'actualInterpolationIterations', [], ...
    'averageReferenceWithNoisyChannels', [], ...
    'noisyOutOriginal', [], ...
    'huberMean', [], ...
    'interpolatedChannelsFromNaNs', [], ...
    'interpolatedChannelsFromNoData', [], ...
    'interpolatedChannelsFromHFNoise', [], ...
    'interpolatedChannelsFromCorrelation', [], ...
    'interpolatedChannelsFromDeviation', [], ...
    'interpolatedChannelsFromRansac', [], ...
    'interpolatedChannelsFromDropOuts', [], ...
    'interpolatedChannels', [], ...
    'badChannelsNotInterpolated', [], ...
    'averageReference', [] ...
    );
referenceOut.referenceChannels = getStructureParameters(params, ...
    'referenceChannels',  1:size(signal.data, 1));
referenceOut.rereferencedChannels =  getStructureParameters(params, ...
    'rereferencedChannels',  1:size(signal.data, 1));
referenceOut.channelLocations = getStructureParameters(params, ...
    'channelLocations', signal.chanlocs);
referenceOut.channelInformation = getStructureParameters(params, ...
    'channelInformation', signal.chaninfo);
referenceOut.maxInterpolationIterations = ...
     getStructureParameters(params, 'maxInterpolationIterations', 4);
referenceOut.actualInterpolationIterations = 0;
%% Check to make sure that reference channels have locations
chanlocs = referenceOut.channelLocations(referenceOut.referenceChannels);
if ~(length(cell2mat({chanlocs.X})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Y})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Z})) == length(chanlocs)) && ...
   ~(length(cell2mat({chanlocs.theta})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.radius})) == length(chanlocs))
   error('robustReference:NoChannelLocations', ...
         'reference channels must have locations');
end

%% Find the noisy channels for the initial starting point
referenceOut.averageReferenceWithNoisyChannels = ...
                nanmean(signal.data(referenceOut.referenceChannels, :), 1);
referenceOut.noisyOutOriginal = findNoisyChannels(signal, params); 

%% Now remove the huber mean and find the channels that are still noisy
unusableChannels = union(...
    referenceOut.noisyOutOriginal.badChannelsFromNaNs, ...
    referenceOut.noisyOutOriginal.badChannelsFromNoData);
referenceChannels = setdiff(referenceOut.referenceChannels, unusableChannels);
[signalTmp, referenceOut.huberMean] = ...
                  removeHuberMean(signal, referenceChannels);
noisyOutHuber = findNoisyChannels(signalTmp, params); 

%% Construct new EEG with interpolated channels to find better average reference
signalTmp = signal;
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels) 
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    signalTmp = interpolateChannels(signalTmp, noisyChannels, sourceChannels);
end
averageReference = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
signal = removeReference(signal, averageReference, ...
                             referenceOut.rereferencedChannels);
clear signalTmp;

%% Now remove reference from the signal iteratively interpolate bad channels
noisyChannelsOld = [];
actualIterations = 0;
paramsNew = params;
paramsNew.referenceChannels = setdiff(params.referenceChannels, ...
                                      unusableChannels);
while actualIterations < referenceOut.maxInterpolationIterations
  noisyOut = findNoisyChannels(signal, paramsNew);
  noisyChannels = union(noisyOut.noisyChannels, unusableChannels);
  sourceChannels = setdiff(params.referenceChannels, noisyChannels);

  if isempty(noisyChannels) || ...
          (isempty(setdiff(noisyChannels, noisyChannelsOld)) && ...
           isempty(setdiff(noisyChannelsOld, noisyChannels)))
      break;
  end
  if length(sourceChannels)  < 2
      error('robustReference:TooManyBad', ...
          'Could not perform a robust reference -- not enough good channels');
  end
  signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
  averageReferenceNew = mean(signalTmp.data(params.referenceChannels, :), 1);
  signal = removeReference(signal, averageReferenceNew, ...
      referenceOut.rereferencedChannels);
  averageReference = averageReference + averageReferenceNew;
  actualIterations = actualIterations + 1;
  noisyChannelsOld = noisyChannels;
end

if ~isempty(noisyChannels)  % Referencing ended with noisy channels
    signal = interpolateChannels(signal, noisyChannels, sourceChannels);
    averageReferenceNew = mean(signal.data(referenceOut.referenceChannels, :), 1);
    signal = removeReference(signal, averageReferenceNew, ...
                             referenceOut.rereferencedChannels);
    averageReference = averageReference + averageReferenceNew;
    referenceOut.interpolatedChannelsFromNaNs = noisyOut.badChannelsFromNaNs;
    referenceOut.interpolatedChannelsFromNoData = noisyOut.badChannelsFromNoData;
    referenceOut.interpolatedChannelsFromHFNoise = noisyOut.badChannelsFromHFNoise;
    referenceOut.interpolatedChannelsFromCorrelation = noisyOut.badChannelsFromCorrelation;
    referenceOut.interpolatedChannelsFromDeviation = noisyOut.badChannelsFromDeviation;
    referenceOut.interpolatedChannelsFromRansac = noisyOut.badChannelsFromRansac;
    referenceOut.interpolatedChannelsFromDropOuts = noisyOut.badChannelsFromDropOuts;
    referenceOut.interpolatedChannels = noisyChannels; 
    noisyOut = findNoisyChannels(signal, params);
    referenceOut.badChannelsNotInterpolated = noisyOut.noisyChannels;
end
referenceOut.noisyOut = noisyOut;
referenceOut.averageReference = averageReference;
referenceOut.actualInterpolationIterations = actualIterations;

