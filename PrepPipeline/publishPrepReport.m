function [] = publishPrepReport(EEG, summaryFilePath, sessionFilePath, ...
                                consoleFID, publishOn)
% Create a published report from the PREP pipeline.
%
% Note: In addition to creating a report for the EEG, it appends a 
% summary of the file to an existing summary file. This enables the
% function to be called successfully on a collection and creates a summary
% of the collection.
%
% Parameters:
%     EEG                 EEGLAB structure with the EEG.etc.noiseDetection
%                         structure created by the PREP pipeline
%     summaryFilePath     File name including path of the summary file
%     sessionFilePath     File name including path of the individual report
%     consoleID           Open file descriptor for echoing output (usually 1
%                         indication the Command Window).
%     publishOn           If true (default), report is published and 
%                         figures are closed. If false, output and figures
%                         are displayed in the normal way. The figures
%                         are not closed. This option is useful when
%                         you want to manipulate the figures in some way.
%
%  Output:
%     If the publish option is on, this function will create a report
%     for the EEG and will append a summary to a specified summary file.
%     If the publish option is off, the function will just run the
%     prepReport script.
%
%  Author:  Kay Robbins, UTSA, March 2015.
%
%
%% Handle the parameters
    if (nargin < 4)
        error('publishPrepReport:NotEnoughParameters', ...
            ['Usage: publishPrepReport(EEG, summaryFilePath, ' ...
            'sessionFilePath, consoleFID, publishOn)']);
    elseif nargin < 5 || isempty(publishOn)
        publishOn = true;
    end

%% Make sure that EEGLAB is working in double precision
    [backupOptionsFile, currentOptionsFile, warningsState] = setupForEEGLAB();
    finishup = onCleanup(@() cleanup(backupOptionsFile, currentOptionsFile, ...
        warningsState));

%% Setup up files and assign variables needed for publish in base workspace
    wrapperScriptName = 'prepReportWrapper';
    [summaryFolder, summaryName, summaryExt] = fileparts(summaryFilePath);
    [sessionFolder, sessionName, sessionExt] = fileparts(sessionFilePath);
    summaryReportLocation = fullfile(summaryFolder, [summaryName summaryExt]);
    sessionReportLocation = fullfile(sessionFolder, [sessionName sessionExt]);
    tempReportLocation = fullfile(sessionFolder, [wrapperScriptName '.pdf']);
    relativeReportLocation = getRelativePath(summaryFolder, sessionFolder, sessionName, sessionExt);

    fprintf('Summary: %s   session: %s\n', summaryFolder, sessionFolder);
    fprintf('Relative report location %s \n', relativeReportLocation);
    
    if isempty(EEG) || ~isfield(EEG, 'etc') || ~isfield(EEG.etc, 'noiseDetection')
        error('publishPrepReport:PrepNotRun', ...
        ['EEG.etc must contain PREP informational structures to ' ...
         'run reports --- run PREP first']);
    end

    if publishOn
        % Save variables to temp file
        dataPath = fullfile(tempdir, 'prepReportData.mat');
        save(dataPath, 'EEG', 'consoleFID', 'relativeReportLocation', 'summaryReportLocation');
    
        % Write wrapper script
        
        wrapperPath = fullfile(tempdir, [wrapperScriptName '.m']);
        fid = fopen(wrapperPath, 'w');
        fprintf(fid, 'load(''%s'');\n', dataPath);
        fprintf(fid, 'summaryFile = fopen(summaryReportLocation, ''a+'', ''n'', ''UTF-8'');\n');
        fprintf(fid, 'prepReport(EEG, summaryFile, consoleFID, relativeReportLocation);\n');
        fprintf(fid, 'fclose(summaryFile);\n');
        fprintf(fid, 'clear consoleFID relativeReportLocation summaryReportLocation summaryFile tmpEEG;\n');
        fclose(fid);

        % Add tempdir to MATLAB path so publish can find the script
        addpath(tempdir);
    
        % Set publish options
        publish_options.outputDir = sessionFolder;
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
    
        % Publish report
        publish(wrapperScriptName, publish_options);

        rmpath(tempdir);
        movefile(tempReportLocation, sessionReportLocation);
        close all;
        delete(wrapperPath);
        delete(dataPath);
    else
        summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
        if summaryFile == -1
           error('publishPrepReport:BadSummaryFile', ...
                'Failed to open summary file %s', summaryReportLocation);
        end
        prepReport(EEG, summaryFile, consoleFID, relativeReportLocation);
        fclose(summaryFile);
        clear consoleFID relativeReportLocation summaryReportLocation summaryFile tmpEEG;
    end

end
 
function relativePath = getRelativePath(summaryFolder, sessionFolder, sessionName, sessionExt)
    relativePath = relativize(getCanonicalPath(summaryFolder), ...
                              getCanonicalPath(sessionFolder));
    relativePath = getCanonicalPath(relativePath);
    while true
        relativePathNew = strrep(relativePath, '\\', '\');
        if length(relativePathNew) == length(relativePath)
            break;
        end
        relativePath = relativePathNew;
    end
    relativePath = strrep(relativePath, '\', '/');
    relativePath = [relativePath sessionName sessionExt];
end

function canonicalPath = getCanonicalPath(canonicalPath)
    if canonicalPath(end) ~= filesep
        canonicalPath = [canonicalPath, filesep];
    end
end

function cleanup(backupFile, currentFile, warningsState)
    restoreEEGOptions(backupFile, currentFile);
    warning(warningsState);
end
