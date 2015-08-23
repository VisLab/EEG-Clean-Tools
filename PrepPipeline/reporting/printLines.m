function printLines(FID, data, lineLength, indent)
% Helper function for printing messages and breaking lines at words.
actualLength = lineLength - length(indent);
remaining = data;
while(~isempty(remaining))
    [s, remaining] = getNextLine(remaining, actualLength);
    fprintf(FID, '%s%s\n', indent, s);   
end

    function [s, remaining] = getNextLine(data, theLength)
        s = '';
        remaining = strtrim(data);
        if isempty(remaining)
            return;
        elseif length(remaining) <= theLength
            s = remaining;
            remaining = '';
            return;
        end
        blankPositions = strfind(remaining, ' '); 
        if isempty(blankPositions) || ...
            min(blankPositions) > theLength + 1; % Must break line
            s = [remaining(1:(theLength - 1)) '-'];
            remaining = remaining(theLength:end);
            return;
        end
        p = blankPositions(blankPositions <= theLength + 1);
        actualPosition = max(p);
        s = remaining(1:(actualPosition - 1));
        remaining = remaining((actualPosition + 1): end);
    end
end