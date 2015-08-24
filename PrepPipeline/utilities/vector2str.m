function str = vector2str(num)
% Converts a vector to string with colon operators
str = num2str(num(1));
incrementStart = true;
for a = 2:length(num)
    if num(a) - num(a-1) == 1
        incrementStart = handleConsecutive(incrementStart);
    else
        incrementStart = handleNonConsecutive(num(a-1), num(a), ...
            incrementStart);
    end
end
handleLastIndex(num(length(num)), incrementStart);

    function incrementStart = handleNonConsecutive(previous, current, ...
            incrementStart)
        % Handles a number that is not a consecutive number
        if ~incrementStart
            str = [str num2str(previous)];
        end
        str = [str ' ' num2str(current)];
        incrementStart = true;
    end % handleNonConsecutive

    function handleLastIndex(last, incrementStart)
        % Handles the last number in the vecor
        if ~incrementStart
            str = [str num2str(last)];
        end
    end % handleLastIndex

    function incrementStart = handleConsecutive(incrementStart)
        % Handles a number that is a consecutive number
        if incrementStart
            str = [str ':'];
            incrementStart = false;
        end
    end % handleConsecutive

end % vector2str