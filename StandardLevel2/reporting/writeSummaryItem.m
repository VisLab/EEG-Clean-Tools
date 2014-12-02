function writeSummaryItem(sumFile, summaryItem, firstlast)
    if nargin == 3 && strcmpi(firstlast, 'first')
       fprintf(sumFile, '\n<ul>\n');
    end
    if ~isempty(summaryItem)
       for k = 1:length(summaryItem)
           if ~isempty(summaryItem{k}) && ischar(summaryItem{k}) && ...
               ~isempty(strtrim(summaryItem{k}))
               fprintf(sumFile, '<li>%s</li>\n', summaryItem{k});
           end
       end
    end
    if nargin == 3 && strcmpi(firstlast, 'last')
       fprintf(sumFile, '</ul>\n');
    end
end
