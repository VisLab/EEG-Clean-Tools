function [mystruct, p] = getSignalParameters(mystruct, myfield, signal, field, value)
% Assigns value to myfield field of structure mystruct the field value
% of signal if it exists, otherwise, it assigns value.
% Returns the final myfield field value in mystruct.
if ~isfield(mystruct, myfield) || isempty(mystruct.(myfield))
    if isfield(signal, field) && ~isempty(signal.(field))
        mystruct.(myfield) = signal.(field);
    else
        mystruct.(myfield) = value;
    end
end
p = mystruct.(myfield);
