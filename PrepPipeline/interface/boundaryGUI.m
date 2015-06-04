function paramsOut = boundaryGUI(hObject, callbackdata, inputData)%#ok<INUSL>
    defaultStruct = inputData.userData.boundary;
    theTitle = 'Boundary parameters';
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if isempty(userdata) || ~isfield(userdata, 'boundary')
       paramsOut = struct();
    else
       paramsOut = userdata.boundary;
    end
    [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);
    if ~isempty(errors)
            warning('boundaryGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
    end
    
    if defaultStruct.ignoreBoundaryEvents.value
        checkValue = 1;
    else
        checkValue = 0;
    end
    %% starts the while loop, sets up the uilist and creates the GUI
    closeOpenWindows(theTitle);
    geometry = {[1,0.9]};
    geomvert = [];
    uilist = {{'style', 'text', 'string', 'Ignore boundary events', ...
        'TooltipString', defaultStruct.ignoreBoundaryEvents.description}...
        {'style', 'checkbox',  'Value', checkValue, ...
        'tag', 'ignoreBoundaryEvents'}};
        [~, ~, ~, paramsOut] = inputgui('geometry', geometry, ...
        'geomvert', geomvert, 'uilist', uilist, 'title', theTitle, ...
        'helpcom', 'pophelp(''pop_prepPipeline'')');
    if (isempty(paramsOut))  % Cancelled out
        return;
    end
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if paramsOut.ignoreBoundaryEvents
       userdata.boundary.ignoreBoundaryEvents = true;  
    else
       userdata.boundary.ignoreBoundaryEvents = false;
    end
    set(mainFigure, 'UserData', userdata);
end