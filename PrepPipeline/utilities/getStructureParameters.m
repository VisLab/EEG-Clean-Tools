function p = getStructureParameters(mystruct, myfield, value)
% Sets p to mystruct.myfield if it exists, other assigns it to value
if  ~exist('value', 'var') && ~isfield(mystruct, myfield)
    error('Either value of mystruct.myfield must exist');
elseif exist('value', 'var') && ~isfield(mystruct, myfield) 
    p = value;
else
    p = mystruct.(myfield);
end
