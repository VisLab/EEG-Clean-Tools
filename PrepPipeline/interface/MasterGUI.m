function MasterGUI(hObject, callbackdata)
    %result = MasterGUI(hObject, callbackdata)
    %save button?-->how do we save the data after they've entered it
    global EEG;
    %signal=pop_loadset();
    signal = EEG;
    geometry = {1, [1, 1], [1, 1], [1, 1], [1, 1, .5], [1, 1, .5]};
    geomvert = [];
    uilist= {{'style', 'text', 'string', 'Override default parameters for processing step:'}...
             {'style', 'pushbutton', 'string', 'Boundary', 'Callback', {@boundaryGUI,signal}}...
             {'style', 'pushbutton', 'string', 'Resample', 'Callback', {@resampleGUI,signal}}...
             {'style', 'pushbutton', 'string', 'Global Trend', 'Callback', {@globalTrendGUI,signal}}...
             {'style', 'pushbutton', 'string', 'Detrend', 'Callback', {@detrendGUI,signal}}...
             {'style', 'pushbutton', 'string', 'Line Noise', 'Callback', {@lineNoiseGUI,signal}}...
             {'style', 'pushbutton', 'string', 'Reference', 'Callback', {@referenceGUI,signal}}...
             {'style', 'checkbox', 'string', 'Save EEG to a File', 'tag', 'checkbox1','Callback', {@checkboxTrigger,'fileNameEEG','browse1','checkbox2','fileNameHDF5','browse2'}}...
             {'style', 'edit', 'string', '', 'tag', 'fileNameEEG', 'Enable', 'off'}...
             {'style', 'pushbutton', 'string', 'Browse', 'tag', 'browse1','Enable', 'off','Callback',{@browseFile,'fileNameEEG'}}...
             {'style', 'checkbox', 'string', 'Save statistics as an HDF5 file', 'tag', 'checkbox2','Callback', {@checkboxTrigger,'fileNameHDF5','browse2','checkbox1','fileNameEEG','browse1'}}...
             {'style', 'edit', 'string', '', 'tag', 'fileNameHDF5', 'Enable', 'off'}...
             {'style', 'pushbutton', 'string', 'Browse','tag','browse2','Enable','off','Callback',{@browseFile,'fileNameHDF5'}}};
            
            
    result = inputgui('geometry', geometry, 'geomvert', geomvert, 'uilist', uilist, 'title', 'EEG Clean Tools Main Menu', 'helpcom', 'pophelp(''pop_eegfiltnew'')');
end
function checkboxTrigger(hObject,callbackdata,buttonTag,browse1,box2,button2,browse2)
    buttonState=findobj('tag',buttonTag);
    box2=findobj('tag',box2);
    button2=findobj('tag',button2);
    browse1=findobj('tag',browse1);
    browse2=findobj('tag',browse2);
    
    box1Value=get(hObject,'Value');
    box2Value=get(box2,'Value');
    
    if(isequal(box1Value,1))
        set(buttonState,'Enable','on');
        set(browse1,'Enable','on');
        if(isequal(box2Value,1))
            set(box2,'Value',0);
            set(button2,'Enable','off');
            set(browse2,'Enable','off');
        end
    end
    if(isequal(box1Value,0))
        set(buttonState,'Enable','off');
        set(browse1,'Enable','off');
    end
end
function browseFile(hObject,callbackdata,buttonName)
    %path or file name?
    fileName=pop_loadset();
    button=findobj('tag',buttonName);
    set(button,'string',fileName.filename);
end