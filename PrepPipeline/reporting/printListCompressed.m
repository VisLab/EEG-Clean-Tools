function [] = printListCompressed(fid, list, perLine, indent)
% Output the values in list in consecutive colon format
    sortList = sort(list);
    fprintf(fid, '%s[ ', indent);
    startList = 1;
    endList = 1;
    count = 1;
    for k = 1:length(list) - 1
        if sortList(k + 1) ~= sortList(k) + 1 
            printElement(startList, endList, false);
            startList = k + 1;
        end 
        endList = k + 1;
    end
    printElement(startList, endList, true);
   
    function [] = printElement(startList, endList, last)
        if startList == endList
            fprintf(fid, '%d ', sortList(startList));
        else
            fprintf(fid, '%d:%d ', sortList(startList), sortList(endList));
        end
        if last
           fprintf(fid, ']\n');
        elseif mod(count, perLine) == 0
            fprintf(fid, '\n%s', indent);
            count = 1;
        else
            count = count + 1;
        end
    end
end