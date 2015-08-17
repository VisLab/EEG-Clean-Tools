function [paramsOut] = resampleGUI(hObject, callbackdata, inputData) %#ok<INUSL>
%gets a structure with the properties and a structure with the default
defaultStruct = inputData.userData.resample;

title = 'Resample parameters';
while(true)
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if isempty(userdata) || ~isfield(userdata, 'resample')
        paramsOut = struct();
    else
        paramsOut = userdata.resample;
    end
    [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);
    
    if ~isempty(errors)
        warning('bad parameters');
    end
    if defaultStruct.resampleOff.value
        checkValue = 1;
    else
        checkValue = 0;
    end
    %creates a structure for the text color of each parameter and sets them
    %all to black
    fNamesDefault = fieldnames(defaultStruct);
    for k = 1:length(fNamesDefault)
        textColorStruct.(fNamesDefault{k}) = 'k';
    end
    
    
    %% starts the while loop, sets up the uilist and creates the GUI
    closeOpenWindows(title);
    geometry = {[1, 1], [1, 1], [1, 1]};
    geomvert = [];
    uilist = {{'style', 'text', 'string', 'Turn resample off', ...
        'TooltipString', defaultStruct.resampleOff.description}...
        {'style', 'checkbox', 'Value', checkValue, ...
        'tag', 'resampleOff', 'ForegroundColor', textColorStruct.resampleOff}...
        {'style', 'text', 'string', 'Resample frequency', ...
        'TooltipString', defaultStruct.resampleFrequency.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.resampleFrequency.value), ...
        'tag', 'resampleFrequency', 'ForegroundColor', ...
        textColorStruct.resampleFrequency}...
        {'style', 'text', 'string', 'Low pass frequency',...
        'TooltipString', ''}...
        {'style', 'edit', 'string', ...
        defaultStruct.lowPassFrequency.value,...
        'tag', 'lowPassFrequency'}};
    [~, ~, ~, paramsOut] = inputgui('geometry', geometry, ...
        'geomvert', geomvert, 'uilist', uilist, 'title', title, ...
        'helpcom', 'pophelp(''pop_prepPipeline'')');
    if isempty(paramsOut)
        break;
    end
    
    [paramsOut, typeErrors, fNamesErrors] = ...
        changeType(paramsOut, defaultStruct);
    
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    userdata.resample = paramsOut;
    set(mainFigure, 'UserData', userdata);
    if isempty(typeErrors)
        break;
    end
    textColorStruct = highlightErrors(fNamesErrors, ...
        fNamesDefault, textColorStruct);
    displayErrors(typeErrors); % Displays the errors and restarts GUI
end
end