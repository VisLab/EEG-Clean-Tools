function relative = relativize(base, target)
% Finds the relative path of one directory to another
base = getCanonicalPath(base);
target = getCanonicalPath(target);
relative = target;
if strcmpi(base,target)
    relative = '.';
    return;
end
escapedBase = escapePathSeparators(base);
[~, endIndex] = regexpi(target, escapedBase, 'once');
if endIndex == length(base)
    relative = ['.', target(endIndex:end)];
else
    targetSeparators = length(find(target == filesep));
    baseSeparators = length(find(base == filesep));
    [poppedTarget, popped] = popDir(target);
    poppedPath = '';
    for a = 1:targetSeparators
        escapedTarget = escapePathSeparators(poppedTarget);
        [~, endIndex] = regexpi(base, escapedTarget, 'once');
        poppedPath = [filesep, popped, poppedPath]; %#ok<AGROW>
        if ~isempty(endIndex)
            previousDirStr = createPreviousDirStr(baseSeparators-a);
            relative = [previousDirStr, poppedPath];
            break;
        end
        [poppedTarget, popped] = popDir(poppedTarget);
    end
end

    function previousStr = createPreviousDirStr(count)
        % Creates a string with the correct number of previous directory
        % commands
        previousStr = '..';
        for b = 1:count
            previousStr = [previousStr, filesep, '..']; %#ok<AGROW>
        end
    end % createPreviousStr

    function escpaedPath = escapePathSeparators(path)
        % Escapes the path separtors 
        escpaedPath = regexprep(path, '\\', '\\\\');
    end % escapePathSeparators

    function canonicalPath = getCanonicalPath(path)
        % Trims and adds a file separator to the end of the path
        canonicalPath = strtrim(path);
        if canonicalPath(end) ~= filesep;
            canonicalPath = [canonicalPath, filesep];
        end
    end % getCanonicalPath

    function [poppedPath, poppedDir] = popDir(path)
        % Pops the directory from the end of the path
        splitStr = strsplit(path, filesep);
        poppedPath = strjoin(splitStr(1:end-1), filesep);
        poppedDir = splitStr{end};
    end % popDir

end % relativize