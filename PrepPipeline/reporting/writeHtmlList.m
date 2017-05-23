function writeHtmlList(sumFile, item, firstLast)
% Write a cell array of strings in an ordered html list  
%
% Parameters:
%    sumFile      Open file descriptor
%    item         Cell array with list items
%    firstLast    (optional) A 'first' rewrites <ul> at beginning
%                  'last' writes </ul> at end, 'both' writes both, 
%                  'none' writes neither (default).
%                
%
% Example:
%    writeHtmlList(Fid, {'FirstLine'}, 'first')
%
% Written by: Kay Robbins, UTSA 2015
%
if nargin < 3
    firstLast = 'none';
end
if strcmpi(firstLast, 'first') || strcmpi(firstLast, 'both')
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
if strcmpi(firstLast, 'last') || strcmpi(firstLast, 'both')
    fprintf(sumFile, '</ul>\n');
end

