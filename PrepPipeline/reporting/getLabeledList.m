function listString = getLabeledList(list, labels, perLine, indent)
% Create a string list with labels for a specified number of values per line
count = 0;
listString = sprintf('%s[ ', indent);
for k = 1:length(list)
    listString = [listString sprintf('%g(%s) ', list(k), labels{k})]; %#ok<AGROW>
    count = count + 1;
    if mod(count, perLine) == 0
        listString = [listString sprintf('\n%s', indent)]; %#ok<AGROW>
        count = 0;
    end
end
listString = [listString sprintf(']')];