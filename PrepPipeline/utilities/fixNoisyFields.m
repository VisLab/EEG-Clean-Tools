function EEG = fixNoisyFields(EEG, referenceType)
%% Update structure fields to agree with latest structure
% Make sure everything is in double precision
% pop_editoptions('option_single', false, 'option_savetwofiles', false);
if isfield(EEG.etc, 'noisyParameters')
    yNoisy = EEG.etc.noisyParameters;
else
    yNoisy = EEG.etc.noiseDetection;
end
noisyRef = yNoisy.reference;
noisyRef.referenceType = referenceType;
%% Remove unused fields
if isfield(noisyRef, 'interpolateHF')
    noisyRef = rmfield(noisyRef, 'interpolateHF');
    fprintf('Removed interpolateHF\n');
end
if isfield(noisyRef, 'huberMean')
    noisyRef = rmfield(noisyRef, 'huberMean');
    fprintf('Removed huberMean');
end

%% Fix up the reference fields
if isfield(noisyRef, 'averageReferenceWithNoisyChannels') && ...
        ~isempty(noisyRef.averageReferenceWithNoisyChannels)
    noisyRef.referenceSignalWithNoisyChannels = ...
        noisyRef.averageReferenceWithNoisyChannels;
    fprintf('Moved averageReferenceWithNoisyChannels to referenceSignalWithNoisyChannels\n');
elseif isfield(noisyRef, 'specificReferenceWithNoisyChannels') && ...
        ~isempty(noisyRef.specificReferenceWithNoisyChannels)
    noisyRef.referenceSignalWithNoisyChannels = ...
        noisyRef.specificReferenceWithNoisyChannels;
    fprintf('Moved averageReferenceWithNoisyChannels to referenceSignalWithNoisyChannels\n');
else
    noisyRef.referenceSignalWithNoisyChannels = [];
    fprintf('---WARNING---- referenceSignalWithNoisyChannels not defined\n');
end

if isfield(noisyRef, 'averageReference') && ...
        ~isempty(noisyRef.averageReference)
    noisyRef.referenceSignal = noisyRef.averageReference;
    fprintf('Moved averageReference to referenceSignal\n');
elseif isfield(noisyRef, 'specificReference') && ...
        ~isempty(noisyRef.specificReference)
    noisyRef.referenceSignal = noisyRef.specificReference;
    fprintf('Moved specificReference to referenceSignal\n');
else
    noisyRef.referenceSignal = [];
    fprintf('---WARNING---- referenceSignal not defined\n');
end
 
%% Now create fix the output structure
newRef = getReferenceStructure();
newRef.referenceType = referenceType;
baseFields = fieldnames(newRef);
for k = 1:length(baseFields)
    newRef.(baseFields{k}) = getFieldIfExists(noisyRef, baseFields{k});
end
yNoisy.reference = newRef;
EEG.etc.noiseDetection = yNoisy;