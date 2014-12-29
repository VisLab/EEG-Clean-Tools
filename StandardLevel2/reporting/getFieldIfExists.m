function value = getFieldIfExists(myStruct, myField)
    if isfield(myStruct, myField)
        value = myStruct.(myField);
    else
        value = [];
    end
end