function writeHtmlList(sumFile, item, firstlast)
% Write a cell array of strings in an ordered html list  
%
% Parameters:
%    sumFile      Open file descriptor
%    item         Cell array with list items
%    firstlast    (optional) If included with value 'first' rewrites <ul>.
%
% Example:
%    writeHtmlList(Fid, {'FirstLine'}, 'first')
%
% Written by: Kay Robbins, UTSA 2015
%
    if nargin == 3 && strcmpi(firstlast, 'first')
       fprintf(sumFile, '\n<ul>\n');
    end
    if ~isempty(item)
       for k = 1:length(item)
           if ~isempty(item{k}) && ischar(item{k}) && ...
               ~isempty(strtrim(item{k}))
               fprintf(sumFile, '<li>%s</li>\n', item{k});
           end
       end
    end
    if nargin == 3 && strcmpi(firstlast, 'last')
       fprintf(sumFile, '</ul>\n');
    end
end
