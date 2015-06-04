%% *****************************displayErrors******************************
%Purpose:
%       This returns the errors (if any) that are found when a user enters
%       data that does not correspond with the type found by the default
%       function. It displays the errors in a pop-up GUI.
%Parameters:
%       I   errors      Cell array of strings; errors found by the
%                       checkDefaults function
%       O   loop        Integer that either continues the while loop found
%                       above or exits the loop
%Notes:
%       
%Return Value:
%       0   No errors
%       1   Displays errors and continues loop
%**************************************************************************
function displayErrors(errors)
    geometry={};
    geomvert=[];
    uilist={};
    for k=1:length(errors)
        geometry={geometry{:},1};
        uilist={uilist{:},{'style', 'text', 'string', errors(k)}};
    end
    result=inputgui('geometry', geometry, 'geomvert', geomvert, 'uilist', uilist, 'title', 'Reference Errors', 'helpcom', 'pophelp(''pop_eegfiltnew'')');
end