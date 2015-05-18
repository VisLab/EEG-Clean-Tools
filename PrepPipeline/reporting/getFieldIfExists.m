function value = getFieldIfExists(myStruct, myField)
% Utility that returns the value of a subfield of a structure if it exists.  
%
% Parameters:
%    myStruct   structure from which value is to be extracted
%    myField    field name or a cell array of field names for navigation
%               to subarray
%    value      (output) the substructure if it exists, otherwise []
%
% Example:
%    To extract EEG.etc.noiseDetection call
%          value = getFieldIfExists(myStruct, {'etc', 'noiseDetection'}
%
% Written by: Kay Robbins, UTSA 2015
%
    if iscellstr(myField) && ~isempty(myField)
        value = myStruct;
        for k = 1:length(myField)
            if isfield(value, myField{k})
                value = value.(myField{k});
            else
                value = [];
                break;
            end
        end
    elseif ischar(myField) && isfield(myStruct, myField)
        value = myStruct.(myField);
    else
        value = [];
    end
end