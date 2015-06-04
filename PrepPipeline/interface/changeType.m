%% *****************************changeType*********************************
%Purpose:
%       This function changes the data type of the parameters returned by 
%       the inputgui function. It allows the parameters to be used as the
%       correct default type.
%Parameters:
%       I       params      Structure of parameters to change data type.
%       I       signal      Structure of data in the EEGlab format.
%       I       defaults    Structure of the default parameters with
%                           attributes.
%       O       outParams   Structure of parameters with correct type.       
%Notes:
%       
%**************************************************************************
function [outParams, errors, errorNames] = changeType(params, defaults)
    %tests each string to make sure it is correct numeric type
    %splits the strings at whitespace and converts each cell to an int
    fNames = fieldnames(defaults);
    errors = cell(0);
    errorNames = cell(0);
    outParams = params;
    for k = 1:length(fNames)
        if strcmpi(defaults.(fNames{k}).classes, 'numeric') == 1
            outParams.(fNames{k}) = str2num(params.(fNames{k}));
            if isempty(outParams.(fNames{k}))
                errors{end + 1} =[fNames{k} ...
                    ': contains at least one character of the incorrect type']; %#ok<AGROW>
                errorNames{end + 1} = fNames{k}; %#ok<AGROW>
            end
        elseif strcmpi(defaults.(fNames{k}).classes, 'logical') == 1
            outParams.(fNames{k}) = logical(params.(fNames{k}));
        end
    end
end