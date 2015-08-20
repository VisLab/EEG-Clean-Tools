function [paramsOut] = postProcessGUI(hObject, callbackdata, inputData) %#ok<INUSL>
title ='Post process parameters';
defaultStruct = inputData.userData.postProcess;
mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
userdata = get(mainFigure, 'UserData');
if isempty(userdata) || ~isfield(userdata, 'postProcess')
    paramsOut = struct();
else
    paramsOut = userdata.postProcess;
end
[defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);

if ~isempty(errors)
    warning('postProcessGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
end
if defaultStruct.cleanupReference.value
    cleanUpCheckValue = 1;
else
    cleanUpCheckValue = 0;
end
if defaultStruct.keepFiltered.value
    filteredCheckValue = 1;
else
    filteredCheckValue = 0;
end
if defaultStruct.removeInterpolatedChannels.value
    removeCheckValue = 1;
else
    removeCheckValue = 0;
end
closeOpenWindows(title);
geometry = {[1, 1], [1, 1], [1, 1]};
geomvert = [];
uilist = {{'style', 'text', 'string', 'Clean up reporting fields', 'TooltipString', ''}...
    {'style', 'checkbox', 'tag', 'cleanupReference', 'Value', cleanUpCheckValue}...
    {'style', 'text', 'string', 'Keep filtered', 'TooltipString', ''}...
    {'style', 'checkbox', 'tag', 'keepFiltered', 'Value', filteredCheckValue}...
    {'style', 'text',  'string', 'Remove bad interpolated channels'}...
    {'style', 'checkbox', 'tag', 'removeInterpolatedChannels', 'Value', removeCheckValue}};
[~, ~, ~, paramsOut] = inputgui('geometry', geometry, ...
    'geomvert', geomvert, 'uilist', uilist, 'title', title, ...
    'helpcom', 'pophelp(''pop_prepPipeline'')');
if (isempty(paramsOut))  % Cancelled out
    return;
end
mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
userdata = get(mainFigure, 'UserData');
if paramsOut.cleanupReference
    userdata.postProcess.cleanupReference = true;
else
    userdata.postProcess.cleanupReference = false;
end
if paramsOut.keepFiltered
    userdata.postProcess.keepFiltered = true;
else
    userdata.postProcess.keepFiltered = false;
end
if paramsOut.removeInterpolatedChannels
    userdata.postProcess.removeInterpolatedChannels = true;
else
    userdata.postProcess.removeInterpolatedChannels = false;
end
set(mainFigure, 'UserData', userdata);
end