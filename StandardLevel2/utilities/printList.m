function [] = printList(list, msg, perLine, indent)
% Output the values in list a specified number of values per line
fprintf('%s%s:\n[ ', indent, msg);
count = 0;
for k = 1:length(list)
    fprintf('%g ', list(k));
    count = count + 1;
    if mod(count, perLine) == 0
        fprintf('\n%s%s', indent, indent);
        count = 0;
    end
end
fprintf(']\n');