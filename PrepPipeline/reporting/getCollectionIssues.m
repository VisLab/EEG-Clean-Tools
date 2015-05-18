function [badFiles, badReasons] = getCollectionIssues(fileList)
%% Generates issue reports for a collection of EEG files in inNames
    badFiles = {};
    badReasons = {};
    for k = 1:length(fileList)
        fileName = fileList{k};
        try    % Ignore non EEG files
            fprintf('%d: ', k);
            EEG = pop_loadset(fileName);
            report = generateIssueReport(EEG);
            if ~isempty(report)
                badFiles{end+1} = fileList{k}; %#ok<AGROW>
                badReasons{end+1} = report; %#ok<AGROW>
            end
        catch Mex
            badFiles{end+1} = fileList{k}; %#ok<AGROW>
            badReasons{end+1} = Mex.message; %#ok<AGROW>
            continue;
        end
    end
