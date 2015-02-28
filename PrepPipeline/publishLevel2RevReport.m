function [] = publishLevel2RevReport(EEG, summaryFolder, summaryReportName, ...
                 sessionFolder, sessionReportName)
   % Session folder is relative to the summary report location
        assignin('base', 'EEG', EEG); 
        tempReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep 'standardLevel2RevReport.pdf'];
        actualReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep sessionReportName];
        summaryReportLocation = [summaryFolder filesep summaryReportName];
        
        summaryFile = fopen(summaryReportLocation, 'a+', 'n', 'UTF-8');
        relativeReportLocation = [sessionFolder filesep sessionReportName];
        consoleFID = 1;
        assignin('base', 'summaryFile', summaryFile);
        assignin('base', 'consoleFID', consoleFID);
        assignin('base', 'relativeReportLocation', relativeReportLocation);
        script_name = 'standardLevel2RevReport.m';
        publish_options.outputDir = [summaryFolder filesep sessionFolder];
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
        writeSummaryItem(summaryFile, '', 'last');
        fclose(summaryFile);
        close all
        movefile(tempReportLocation, actualReportLocation);
end
