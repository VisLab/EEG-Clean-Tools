function [collections, collectionStats] = getCollections(collectionFiles)
% Return a cell array of collections and a structure of statistics
collections = cell(length(collectionFiles), 1);
for k = 1:length(collections)
    fprintf('%d: %s\n', k, collectionFiles{k});
    x = load(collectionFiles{k});
    xName = fieldnames(x);
    collections{k} = x.(xName{1});
end
collectionStats = [];
