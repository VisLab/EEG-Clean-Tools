function textColorStruct=highlightErrors(fNamesErrors,fNamesDefault,textColorStruct)
    %if there was an error, changes the color of text to red
    for k=1:length(fNamesErrors)
        textColorStruct.(fNamesErrors{k})='r';
    end
    %if the parameter no longer has an error, changes text
    %color back to black
    for k=1:length(fNamesDefault)
        if(ismember(fNamesDefault{k},fNamesErrors)==0 && textColorStruct.(fNamesDefault{k})=='r')
            textColorStruct.(fNamesDefault{k})='k';
        end
    end
end