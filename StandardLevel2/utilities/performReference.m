function [signal, referenceOut] = performReference(signal, referenceIn)
% Perform the specified reference

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
if strcmpi(referenceOut.referenceType, 'robust') 
    referenceOut.evaluationChannels = referenceOut.referenceChannels;
    [signal, referenceOut] = robustReference(signal, referenceOut); 
elseif strcmpi(referenceOut.referenceType, 'average') 
    referenceOut.evaluationChannels = referenceOut.referenceChannels;
    [signal, referenceOut] = specificReference(signal, referenceOut); 
elseif strcmpi(referenceOut.referenceType, 'specific')
   if length(union(referenceOut.referenceChannels, ...
                    referenceOut.evaluationChannels)) ...
            == length(referenceOut.referenceChannels)
     warning('performReference:DifferentReference', ...
         ['The evaluation channels for interpolation should be different ' ...
         'from the reference channels for specific reference']);
   end
   [signal, referenceOut] = specificReference(signal, referenceOut);
else
    error('performReference:UnsupportedReferenceStrategy', ...
        [referenceOut.referenceType ' is not supported']);
end

