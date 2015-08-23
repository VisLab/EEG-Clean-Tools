function s = getString(data)
% Tries to output data as a string or returns an empty string
    s = '';
    try
        if iscellstr(data)
            s = getMessageString(data);
        elseif ischar(data)
            s = data;
        elseif isnumeric(data)
            s = getListString(data);
        elseif isstruct(data)
            s = getStructureString(data);
        end
    catch mex %#ok<NASGU>
    end