function sString = getStructureString(theStruct)
% Returns a string with the structure values in it
sString = '';
if ~isstruct(theStruct) || isempty(theStruct)
    return;
end
fields = fieldnames(theStruct);
for k = 1:length(fields)
    sString = [sString ' ' fields{k} ':' num2str(theStruct.(fields{k}))]; %#ok<AGROW>
end

