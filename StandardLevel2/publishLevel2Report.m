function [] = publishLevel2Report(EEG, summaryFolder, summaryReportName, ...
                 sessionFolder, sessionReportName)
   % Session folder is relative to the summary report location
        assignin('base', 'EEG', EEG); 
        tempReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep 'standardLevel2Report.pdf'];
        actualReportLocation = [summaryFolder filesep sessionFolder ...
                                    filesep sessionReportName];
        assignin('base', 'summaryFolder', summaryFolder);
        assignin('base', 'summaryReportName', summaryReportName);
        assignin('base', 'sessionFolder', sessionFolder);
        assignin('base', 'sessionReportName', sessionReportName); 
        script_name = 'standardLevel2Report.m';
        publish_options.outputDir = [summaryFolder filesep sessionFolder];
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
        close all
        movefile(tempReportLocation, actualReportLocation);
end

