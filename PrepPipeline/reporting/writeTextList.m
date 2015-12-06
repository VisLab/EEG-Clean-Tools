function writeTextList(fid, items)
% Write a cell array of strings on consecutive lines, skipping empty cells
%
% Parameters:
%    fid          Open file descriptor
%    items        Cell array with list items
%    firstlast    (optional) If included with value 'first' rewrites <ul>.
%
% Example:
%    writeTextList(fID, {'FirstLine'; 'NextLine'})
%
% Written by: Kay Robbins, UTSA 2015
%
    if ~isempty(items)
       for k = 1:length(items)
           if ~isempty(items{k}) && ischar(items{k}) && ...
               ~isempty(strtrim(items{k}))
               fprintf(fid, '%s\n', items{k});
           end
       end
    end

end
