%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
datadir = 'N:\\ARLAnalysis\\VEPStandardLevel2B';
htmlbase = 'N:\\ARLAnalysis\\VEPStandardLevel2ReportsB';
basename = 'vep';
%% Run the pipeline
for k = 1%:18
    thisFile = sprintf('%s_%02d', basename, k);
    fname = [datadir filesep thisFile '.set'];
    load(fname, '-mat');
    publishLevel2Report(EEG, htmlbase, thisFile);
end

