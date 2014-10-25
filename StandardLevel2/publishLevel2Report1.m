function [] = publishLevel2Report1(EEG, sessionFolder, reportFilename)
fprintf('In publish report\n');
who
x = EEG.etc;
fieldnames(x)
        script_name = 'standardLevel2Report1.m';
        publish_options.outputDir = sessionFolder;
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish_options.showCode = false;
        publish(script_name, publish_options);
        close all
        movefile([sessionFolder filesep 'standardLevel2Report1.pdf'], ...
                  [sessionFolder filesep reportFilename]);
end

