function [] = printList(list, perLine, indent)
% Output the values in list a specified number of values per line
count = 0;
fprintf('%s[ ', indent);
for k = 1:length(list)
    fprintf('%g ', list(k));
    count = count + 1;
    if mod(count, perLine) == 0
        fprintf('\n%s', indent);
        count = 0;
    end
end
fprintf(']\n');