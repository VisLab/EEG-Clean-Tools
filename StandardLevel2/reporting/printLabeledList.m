function [] = printLabeledList(fid, list, labels, perLine, indent)
% Output the values in list with labels for a specified number of values per line
count = 0;
fprintf(fid, '%s[ ', indent);
for k = 1:length(list)
    fprintf(fid, '%g(%s) ', list(k), labels{k});
    count = count + 1;
    if mod(count, perLine) == 0
        fprintf(fid, '\n%s', indent);
        count = 0;
    end
end
fprintf(']\n');