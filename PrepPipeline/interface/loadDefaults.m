%% *****************************loadDefaults*******************************
%Purpose:
%       Loads the default values from the signal to put into the GUI.
%Parameters:
%       I   signal          Structure from the EEG data set signal.
%       I   tags            Cell array listing the names of the parameters.
%       O   defaultParams   Return structure of defaults to place into GUI.
%Notes:
%
% *************************************************************************
function [defaultParams, defaultValues] = loadDefaults(signal, type)
    defaultValues = struct();
    defaultParams = getPrepDefaults(signal,type);
    fNames = fieldnames(defaultParams);
    for k = 1:length(fNames)
       if strcmp(defaultParams.(fNames{k}).classes,'struct')==0
            changeStr = num2str(defaultParams.(fNames{k}).default);
            defaultParams.(fNames{k}).default = changeStr;
            sFind = strfind(defaultParams.(fNames{k}).default,'[');
            defaultParams.(fNames{k}).default(sFind) = [];
            sFind = strfind(defaultParams.(fNames{k}).default,']');
            defaultParams.(fNames{k}).default(sFind) = [];
       end
    end
    for k = 1:length(fNames)
        setVal = defaultParams.(fNames{k}).default;
        defaultValues.(fNames{k}) = setVal;
    end
end