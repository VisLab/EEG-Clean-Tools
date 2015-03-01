function referenceOut = findReference(signal, referenceIn)
% Find the reference and the bad channels with respect to that reference
pop_editoptions('option_single', false, 'option_savetwofiles', false);
%% Check the input parameters
if nargin < 1
    error('findReference:NotEnoughArguments', 'requires at least 1 argument');
elseif isstruct(signal) && ~isfield(signal, 'data')
    error('findReference:NoDataField', 'requires a structure data field');
elseif size(signal.data, 3) ~= 1
    error('findReference:DataNotContinuous', 'signal data must be a 2D array');
elseif size(signal.data, 2) < 2
    error('findReference:NoData', 'signal data must have multiple points');
elseif ~exist('referenceIn', 'var') || isempty(referenceIn)
    referenceIn = struct();
end
if ~isstruct(referenceIn)
    error('findReference:NoData', 'second argument must be a structure')
end

%% Set the defaults and initialize as needed
referenceOut = getReferenceStructure();
defaults = getPipelineDefaults(signal, 'reference');
[referenceOut, errors] = checkDefaults(referenceIn, referenceOut, defaults);
if ~isempty(errors)
    error('findReference:BadParameters', ['|' sprintf('%s|', errors{:})]);
end
referenceOut.rereferencedChannels = sort(referenceOut.rereferencedChannels);
referenceOut.referenceChannels = sort(referenceOut.referenceChannels);
referenceOut.evaluationChannels = sort(referenceOut.evaluationChannels);
if isfield(referenceOut, 'reportingLevel') && ...
    strcmpi(referenceOut.reportingLevel, 'verbose');
    referenceOut.noisyStatisticsOriginal = findNoisyChannels(signal, referenceIn);
end
%% The reference
if strcmpi(referenceOut.referenceType, 'robust') 
    referenceOut.evaluationChannels = referenceOut.referenceChannels;
    referenceOut = robustReference(signal, referenceOut); 
elseif strcmpi(referenceOut.referenceType, 'average') 
    referenceOut.evaluationChannels = referenceOut.referenceChannels;
    referenceOut = specificReference(signal, referenceOut); 
elseif strcmpi(referenceOut.referenceType, 'specific')
   if length(union(referenceOut.referenceChannels, ...
                    referenceOut.evaluationChannels)) ...
            == length(referenceOut.referenceChannels)
     warning('findReference:DifferentReference', ...
         ['The evaluation channels for interpolation should be different ' ...
         'from the reference channels for specific reference']);
   end
   referenceOut = specificReferenceNew(signal, referenceOut);
else
    error('findReference:UnsupportedReferenceStrategy', ...
        [referenceOut.referenceType ' is not supported']);
end

