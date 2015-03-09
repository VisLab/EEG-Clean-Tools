function [] = publishPrepPipelineReport(EEG, summaryFolder, summaryReportName, ...
                 sessionFolder, sessionReportName, publishOn)
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
    assignin('base', 'EEG', EEG);
    tempReportLocation = [summaryFolder filesep sessionFolder ...
        filesep 'prepPipelineReport.pdf'];
    actualReportLocation = [summaryFolder filesep sessionFolder ...
        filesep sessionReportName];
    summaryReportLocation = [summaryFolder filesep summaryReportName];

    summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
    relativeReportLocation = [sessionFolder filesep sessionReportName];
    consoleFID = 1;
    assignin('base', 'summaryFile', summaryFile);
    assignin('base', 'consoleFID', consoleFID);
    assignin('base', 'relativeReportLocation', relativeReportLocation);
    script_name = 'prepPipelineReport.m';
    if publishOn
        publish_options.outputDir = [summaryFolder filesep sessionFolder];
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
    else
        prepPipelineReport;
    end
    writeSummaryItem(summaryFile, '', 'last');
    fclose(summaryFile);
    close all
    if publishOn
        movefile(tempReportLocation, actualReportLocation);
    end
end
