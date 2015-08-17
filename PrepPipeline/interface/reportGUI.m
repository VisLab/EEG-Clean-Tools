function [paramsOut] = reportGUI(hObject, callbackdata, inputData) %#ok<INUSL>
title = 'Report parameters';
defaultStruct = inputData.userData.report;
reportCallback   = ['defaultFile = get(findobj(''parent'', gcbf, ''tag'', ''reportName''), ''String'');' ...
    ' [tmpfile tmppath] = uiputfile(''.pdf'', ''Enter filename'', defaultFile); drawnow;' ...
    'if tmpfile ~= 0,' ...
    '    set(findobj(''parent'', gcbf, ''tag'', ''reportName''), ''string'', fullfile(tmppath, tmpfile));' ...
    'end;' ...
    'clear tmpuserdat tmpfile tmppath;'];
summaryCallback   = [' defaultFile = get(findobj(''parent'', gcbf, ''tag'', ''summaryName''), ''String'');' ...
    ' [tmpfile tmppath] = uiputfile(''.html'', ''Enter filename'', defaultFile); drawnow;' ...
    'if tmpfile ~= 0,' ...
    '    set(findobj(''parent'', gcbf, ''tag'', ''summaryName''), ''string'', fullfile(tmppath, tmpfile));' ...
    'end;' ...
    'clear tmpuserdat tmpfile tmppath;'];
while(true)
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if isempty(userdata) || ~isfield(userdata, 'report')
        paramsOut = struct();
    else
        paramsOut = userdata.report;
    end
    [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);
    
    if ~isempty(errors)
        warning('reportGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
    end
    if defaultStruct.publishOn.value
        publishCheckValue = 1;
    else
        publishCheckValue = 0;
    end
    %creates a structure for the text color of each parameter and sets them
    %all to black
    fNamesDefault = fieldnames(defaultStruct);
    for k = 1:length(fNamesDefault)
        textColorStruct.(fNamesDefault{k}) = 'k';
    end
    report = [defaultStruct.reportFolder.value ...
        defaultStruct.reportName.value];
    summary = [defaultStruct.summaryFolder.value ...
        defaultStruct.summaryName.value];
    geometry = {[1, 1], [1,2,1], [1,2,1]};
    geomvert = [];
    closeOpenWindows(title);
    uilist = {{'style', 'text', 'string', 'Publish on', ...
        'TooltipString', defaultStruct.publishOn.description}...
        {'style', 'checkbox', 'Value', publishCheckValue, ...
        'tag', 'publishOn', 'ForegroundColor', textColorStruct.publishOn}...
        {'style', 'text', 'string', 'Report file name'}...
        {'style', 'edit', 'string', report, 'tag', 'reportName', 'userdata', 'reportName'}...
        {'style', 'pushbutton', 'string', 'Browse', 'callback', reportCallback, 'userdata', 'reportName'}...
        {'style', 'text', 'string', 'Summary file name'}...
        {'style', 'edit', 'string', summary, 'tag', 'summaryName'}...
        {'style', 'pushbutton', 'string', 'Browse', 'callback', summaryCallback, 'userdata', 'summaryName'}};
    [~, ~, ~, paramsOut] = inputgui('geometry', geometry, ...
        'geomvert', geomvert, 'uilist', uilist, 'title', title, ...
        'helpcom', 'pophelp(''pop_prepPipeline'')');
    if isempty(paramsOut)
        break;
    end
    
    [pathstr,name,ext] = fileparts(paramsOut.summaryName);
    paramsOut.summaryName = [name ext];
    paramsOut.summaryFolder = [pathstr filesep];
    [~,name,ext] = fileparts(paramsOut.reportName);
    paramsOut.reportName = [name ext];
    paramsOut.reportFolder = [pathstr filesep];
    
    [paramsOut, typeErrors, fNamesErrors] = ...
        changeType(paramsOut, defaultStruct);
    
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    userdata.report = paramsOut;
    set(mainFigure, 'UserData', userdata);
    if isempty(typeErrors)
        break;
    end
    textColorStruct = highlightErrors(fNamesErrors, ...
        fNamesDefault, textColorStruct);
    displayErrors(typeErrors); % Displays the errors and restarts GUI
end