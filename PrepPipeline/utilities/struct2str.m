function [str] = struct2str(struct)
% Converts a struct into a string
str = '';
fNames = fieldnames(struct);
if ~isempty(fNames)
    str = 'struct(';
    for a = 1:length(fNames)
        if ischar(struct.(fNames{a}))
            handleStr(a, struct, fNames);
        elseif islogical(struct.(fNames{a}))
            handleLogical(a, struct, fNames);
        else
            handleNumerical(a, struct, fNames);
        end
    end
    str = [str ')'];
end

    function handleLogical(indx, struct, fNames)
        % Appends a logical structure field to the string
        if struct.(fNames{1})
            str = [str '''' fNames{indx} ''', ' ...
                'true'];
        else
            str = [str '''' fNames{indx} ''', ' ...
                'false'];
        end
    end  % handleLogical

    function handleNumerical(indx, struct, fNames)
        % Appends a numerical structure field to the string
        if isscalar(struct.(fNames{indx}))
            str = [str '''' fNames{indx} ''', ' ...
                num2str(struct.(fNames{indx})) ];
        else
            str = [str '''' fNames{1} ''', ' ...
                '[' num2str(struct.(fNames{indx})) ']'];
        end
    end % handleNumerical

    function handleStr(indx, struct, fNames)
        % Appends a string structure field to the string
        str = [str ','  '''' fNames{indx} ''', ' ...
            '''' struct.(fNames{indx}) ''''];
    end % handleStr

end % struct2str