function [structOut, errors] = checkStructureDefaults(params, defaults)
% Check params input parameter values against defaults put in structOut
errors = cell(0);
fNames = fieldnames(defaults);
structOut = defaults;
for k = 1:length(fNames)
    try
       nextValue = getStructureParameters(params, fNames{k}, ...
                                          defaults.(fNames{k}).value);
       validateattributes(nextValue, defaults.(fNames{k}).classes, ...
                         defaults.(fNames{k}).attributes);
       structOut.(fNames{k}).value = nextValue;
    catch mex
        errors{end + 1} = [fNames{k} ' invalid: ' mex.message]; %#ok<AGROW>
    end
end