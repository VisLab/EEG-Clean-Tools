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
%     EEG           EEGLAB structure with the EEG.etc.noiseDetection
%                   structure created by the PREP pipeline
%     summaryFolder Directory where collection summary is stored.
%     summaryReportName   Name of the collection summary report.
%     sessionFolder       Directory where individual EEG PREP report
%                         should be stored
%     sessionReportName   Name of the report for the session represented
%                         by EEG.
%     publishOn           (optional) if true or omitted, the MATLAB
%                         publish feature will create an actual published
%                         report.
%
%  Output:
%     If the publish option is on, this function will create a report
%     for the EEG and will append a summary to a specified summary file.
%     If the publish option is off, the function will just run the
%     prepPipelineReport script.
%
%  Author:  Kay Robbins, UTSA, March 2015.
%
%
%% Handle the parameters
if (nargin < 5)
    error('publishPrepPipelineReport:NotEnoughParameters', ...
        ['Usage: publishPrepPipelineReport(EEG, summaryFolder, ' ...
        'summaryReportName, sessionFolder, sessionReportName, publishOn)']);
elseif nargin < 6 || isempty(publishOn)
    publishOn = true;
end

%% Setup up files and assign variables needed for publish in base workspace
% Session folder is relative to the summary report location
    [summaryFolder, summaryName, summaryExt] = fileparts(summaryFilePath);
    [sessionFolder, sessionName, sessionExt] = fileparts(sessionFilePath);
    summaryReportLocation = [summaryFolder filesep summaryName summaryExt];
    sessionReportLocation = [sessionFolder filesep sessionName sessionExt];
    tempReportLocation = [sessionFolder filesep 'prepPipelineReport.pdf'];
    relativeReportLocation = getRelativePath(summaryFolder, sessionFolder, ...
        sessionName, sessionExt);
    fprintf('Summary: %s   session: %s\n', summaryFolder, sessionFolder);
    fprintf('Relative report location %s \n', relativeReportLocation);
    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    if summaryFile == -1;
        error('publishPrepReport:BadSummaryFile', ...
            'Failed to open summary file %s', summaryReportLocation);
    end
    assignin('base', 'EEGReporting', EEG);
    assignin('base', 'summaryFile', summaryFile);
    assignin('base', 'consoleFID', consoleFID);
    assignin('base', 'relativeReportLocation', relativeReportLocation);
    script_name = 'prepPipelineReport.m';
    if publishOn
        publish_options.outputDir = sessionFolder;
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
    else
        prepPipelineReport;
    end
    writeSummaryItem(summaryFile, '', 'last');
    fclose(summaryFile);
    if publishOn 
        fprintf('temp report location %s\n', tempReportLocation);
        fprintf('session report location %s\n', sessionReportLocation);
        movefile(tempReportLocation, sessionReportLocation);
        close all
    end
end

function relativePath = getRelativePath(summaryFolder, sessionFolder, ...
                        sessionName, sessionExt)
      relativePath = relativize(getCanonicalPath(summaryFolder), ...
                               getCanonicalPath(sessionFolder));
      relativePath = getCanonicalPath(relativePath);
      while(true)
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