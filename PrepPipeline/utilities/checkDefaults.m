function [structOut, errors, fNamesErrors] = checkDefaults(structIn, structOut, defaults)
% Check structIn input parameters against defaults put in structOut
errors = cell(0);
fNamesErrors=cell(0);
fNames = fieldnames(defaults);
for k = 1:length(fNames)
    try
       nextValue = getStructureParameters(structIn, fNames{k}, ...
                                          defaults.(fNames{k}).default);
       validateattributes(nextValue, defaults.(fNames{k}).classes, ...
                         defaults.(fNames{k}).attributes);
       structOut.(fNames{k}) = nextValue;
    catch mex
        errors{end+1} = [fNames{k} ' invalid: ' mex.message]; %#ok<AGROW>
        fNamesErrors{end+1}=fNames{k}; %#ok<AGROW>
    end
end