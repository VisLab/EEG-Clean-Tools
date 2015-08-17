function theStruct = vargin2struct(inputArgs)
% Converts a variable array to a structure.
theStruct = struct();
if ~iscell(inputArgs) || isempty(inputArgs)
    return;
end

if mod(length(inputArgs), 2) ~= 0
    warning('varargin2struct:NotNameValue', ...
            'Variable list does not represent name-value pairs');
    return;
end
for k = 1:2:length(inputArgs)
    if ~ischar(inputArgs{k})
        warning('varargin2struct:NameNotString', ...
            ['Variable list item ' num2str(k) ' should be a string']);
        return;
    end
end
for k = 1:2:length(inputArgs)
    theStruct.(inputArgs{k}) = inputArgs{k+1};
end
