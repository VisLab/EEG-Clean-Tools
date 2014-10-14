%% Read in the file and set the necessary parameters
datadir = 'N:\\ARLAnalysis\\RSVPStandardLevel2';
htmlbase = 'N:\\ARLAnalysis\\RSVPStandardLevel2Reports';
basename = 'rsvp';
publishReport = 0;
%% Run the pipeline
for k = 3%[1:7, 9:15]
    thisFile = sprintf('%s_%02d', basename, k);
    fname = [datadir filesep thisFile '.set'];
    load(fname, '-mat');
    if ~publishReport
        standardLevel2Report;
    else
        htmldir = [htmlbase filesep thisFile];
        if ~exist(htmldir, 'dir')
            mkdir(htmldir)
        end
        script_name = 'standardLevel2Report';
        publish_options.outputDir = htmldir;
        publish_options.maxWidth = 800;
        publish_options.format = 'pdf';
        publish(script_name, publish_options);
        close all
        fclose('all');
    end
end

