function [] = publishLevel2Report(EEG, sessionFolder, reportFilename)
        script_name = 'standardLevel2Report.m';
        publish_options.outputDir = sessionFolder;
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
        close all
        movefile([sessionFolder filesep 'standardLevel2Report.pdf'], ...
                  [sessionFolder filesep reportFilename]);
end

