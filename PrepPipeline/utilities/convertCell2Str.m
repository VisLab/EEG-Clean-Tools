function str = convertCell2Str(cellStrArray)
%% Convert a cell array of strings to a single char array
%
%  Parameters:
%      cellStrArray   A char array or cell array containing char 
%      str            (output) A single string representation of input

%% Test cellStrArray and convert
if isempty(cellStrArray)
    str = '';
elseif ischar(cellStrArray)
    str = ['[' cellStrArray ']'];
else
    str = ['[' cellStrArray{1} ']'];
    for k = 2:length(cellStrArray)
        str = [str ' [' cellStrArray{k} ']']; %#ok<*AGROW>
    end
end