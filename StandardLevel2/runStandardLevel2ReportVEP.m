%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
datadir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
%datadir = 'K:\\CTAData\\VEPStandardLevel2';
htmlbase = 'N:\\ARLAnalysis\\VEPStandardLevel2Reports';
basename = 'vep';
publishReport = 1;
%% Run the pipeline
for k = 1:18
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

