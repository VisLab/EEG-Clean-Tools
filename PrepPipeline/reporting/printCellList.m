function [] = printCellList(fid, cellList, indent)
% Output the values in cellList one per line with indent in front
for k = 1:length(cellList)
    fprintf(fid, '%s%s\n',indent, num2str(cellList{k}));
end
