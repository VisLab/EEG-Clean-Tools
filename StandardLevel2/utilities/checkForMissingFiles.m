function [missing, present] = checkForMissingFiles(dirname, fileList)
% Returns a list of present and missing files for dirname 

%% Determine which files in the list are in the directory
presentMask = true(size(fileList));
for k = 1:length(fileList)
    fileName = [dirname filesep, fileList{k}];
    if ~exist(fileName, 'file')
        presentMask(k) = false;
    end
end;

present = fileList(presentMask);
missing = fileList(~presentMask);