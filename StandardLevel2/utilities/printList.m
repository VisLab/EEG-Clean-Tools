function [] = printList(list, msg, perLine)
% Output the values in list a specified number of values per line
fprintf('\t\t%s:\n\t\t[ ', msg);
count = 0;
for k = 1:length(list)
    fprintf('%g ', list(k));
    count = count + 1;
    if mod(count, perLine) == 0
        fprintf('\n\t\t');
        count = 0;
    end
end
fprintf(']\n');