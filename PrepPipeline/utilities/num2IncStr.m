function str = num2IncStr(num)
% Converts a number to string with colon operators
str = num2str(num(1));
incrementStart = true;
for a = 2:length(num)
    if num(a) - num(a-1) == 1
        incrementStart = handleSequence(incrementStart);
    else
        incrementStart = handleNonSequence(num(a-1), num(a), ...
            incrementStart);
    end
end
handleLastIndex(num(length(num)), incrementStart);

    function incrementStart = handleNonSequence(previous, current, ...
            incrementStart)
        % Handles a number that is not in a sequence
        if ~incrementStart
            str = [str num2str(previous)];
        end
        str = [str ',' num2str(current)];
        incrementStart = true;
    end % handleNonSequence

    function handleLastIndex(last, incrementStart)
        % Handles the last number that is in a sequence or not
        if ~incrementStart
            str = [str num2str(last)];
        end
    end % handleLastIndex

    function incrementStart = handleSequence(incrementStart)
        % Handles a number that is the start of a sequence
        if incrementStart
            str = [str ':'];
            incrementStart = false;
        end
    end % handleSequence

end % num2IncStr