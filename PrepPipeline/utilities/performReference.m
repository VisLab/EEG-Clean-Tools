function [signal, referenceOut] = performReference(signal, signalFiltered, referenceIn)
% Perform the specified reference
pop_editoptions('option_single', false, 'option_savetwofiles', false);
%% Check the input parameters
if nargin < 1
    error('performReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('performReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('performReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('performReference:NoData', 'signal data must have multiple points');
elseif ~exist('referenceIn', 'var') || isempty(referenceIn)
    referenceIn = struct();
end
if ~isstruct(referenceIn)
    error('performReference:NoData', 'second argument must be a structure')
end

%% Set the defaults and initialize as needed
referenceOut = getReferenceStructure();
defaults = getPipelineDefaults(signal, 'reference');
[referenceOut, errors] = checkDefaults(referenceIn, referenceOut, defaults);
if ~isempty(errors)
    error('performReference:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
referenceOut.rereferencedChannels = sort(referenceOut.rereferencedChannels);
referenceOut.referenceChannels = sort(referenceOut.referenceChannels);
referenceOut.evaluationChannels = sort(referenceOut.evaluationChannels);
if isfield(referenceOut, 'reportingLevel') && ...
        strcmpi(referenceOut.reportingLevel, 'verbose');
    referenceOut.noisyStatisticsOriginal = ...
        findNoisyChannels(signalFiltered, referenceOut);
end

%% Make sure that reference channels have locations for interpolation
chanlocs = referenceOut.channelLocations(referenceOut.referenceChannels);
if ~(length(cell2mat({chanlocs.X})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Y})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.Z})) == length(chanlocs)) && ...
   ~(length(cell2mat({chanlocs.theta})) == length(chanlocs) && ...
     length(cell2mat({chanlocs.radius})) == length(chanlocs))
   error('robustReference:NoChannelLocations', ...
         'reference channels must have locations');
end

%% The reference
if strcmpi(referenceOut.referenceType, 'robust')
    referenceOut = robustReference(signalFiltered, referenceOut);
elseif strcmpi(referenceOut.referenceType, 'average')
    u = union(referenceOut.referenceChannels,referenceOut.evaluationChannels);
    if length(u) ~= length(referenceOut.referenceChannels) || ...
            length(u) ~= length(referenceOut.evaluationChannels)
        warning('performReference:averageReference', ...
            'The evaluation channels for interpolation should be the reference channels');
    end
elseif strcmpi(referenceOut.referenceType, 'specific')
    if length(union(referenceOut.referenceChannels, ...
            referenceOut.evaluationChannels)) ...
            == length(referenceOut.referenceChannels)
        warning('performReference:specificReference', ...
            'The evaluation channels for interpolation should not be reference channels');
    end
else
    error('performReference:UnsupportedReferenceStrategy', ...
        [referenceOut.referenceType ' is not supported']);
end

if ~isempty(referenceOut.referenceChannels)
    referenceOut.referenceSignalOriginal = ...
        nanmean(signal.data(referenceOut.referenceChannels, :), 1);
else
    referenceOut.referenceSignalOriginal = ...
        zeros(1, size(signal.data, 2));
end

noisyChannels = referenceOut.interpolatedChannels.all;
if ~isempty(noisyChannels) && strcmpi(referenceOut.referenceType, 'robust')
    sourceChannels = setdiff(referenceOut.evaluationChannels, noisyChannels);
    signal = interpolateChannels(signal, noisyChannels, sourceChannels);
    referenceSignal = ...
        mean(signal.data(referenceOut.referenceChannels, :), 1);
else
    referenceSignal = referenceOut.referenceSignalOriginal;
end
signal = removeReference(signal, referenceSignal, ...
    referenceOut.rereferencedChannels);
referenceOut.referenceSignal = referenceSignal;
signalClean = removeTrend(signal, referenceIn);
referenceOut.noisyStatistics = findNoisyChannels(signalClean, referenceOut);

% Interpolate bad channels after non-robust referencing
if ~strcmpi(referenceOut.referenceType, 'robust') 
    referenceOut.interpolatedChannels = ...
        updateBadChannels(referenceOut.interpolatedChannels, ...
             referenceOut.noisyStatistics.noisyChannels);
    noisyChannels = referenceOut.interpolatedChannels.all;
    if ~isempty(noisyChannels)
        sourceChannels = setdiff(referenceOut.evaluationChannels, noisyChannels);
        signal = interpolateChannels(signal, noisyChannels, sourceChannels);
        signalClean = removeTrend(signal, referenceIn);
        referenceOut.noisyStatistics = findNoisyChannels(signalClean, referenceOut);
    end 
end    
if referenceOut.keepFiltered
    signal = signalClean;
end
clear signalClean;

