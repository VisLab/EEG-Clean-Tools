function [str] = struct2str(theStruct)
% Converts a struct into a string
str = '';
fNames = fieldnames(theStruct);
if isempty(fNames)
  return;
end
str = 'struct(';
for a = 1:length(fNames)
    if ischar(theStruct.(fNames{a}))
        strVal = getStr(a);
    elseif islogical(theStruct.(fNames{a}))
        strVal = getLogical(a);
    else
        strVal = getNumerical(a);
    end
    str = [str '''' fNames{a} ''', ' strVal]; %#ok<AGROW>
end
if strcmpi(str(end-1), ',')
    str = str(1:end-2);
end
str = [str ')'];

    function strVal = getLogical(indx)
        % Appends a logical structure field to the string
        if theStruct.(fNames{indx})
            strVal = 'true, ';
        else
            strVal = 'false, ';
        end
    end  % getLogical

    function strVal = getNumerical(indx)
        % Appends a numerical structure field to the string
        if isscalar(theStruct.(fNames{indx}))
           strVal = [num2str(theStruct.(fNames{indx})) ', '];
        else
           strVal = ['[' num2str(theStruct.(fNames{indx})) '], '];
        end
    end % getNumerical

    function strVal = getStr(indx)
        % Appends a string structure field to the string
      strVal = ['''' theStruct.(fNames{indx}) ''', '];
    end % handleStr

end % struct2str