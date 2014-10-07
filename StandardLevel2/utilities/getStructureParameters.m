function [mystruct, p] = getStructureParameters(mystruct, myfield, value)
% Assigns value to myfield field of structure mystruct if no value exists.
% Returns the final myfield field value in mystruct.
if  ~exist('value', 'var') && ~isfield(mystruct, myfield)
    error(['Parameter ' myfield ' is not defined']);
elseif exist('value', 'var') && ~isfield(mystruct, myfield) 
    mystruct.(myfield) = value;
end
p = mystruct.(myfield);
