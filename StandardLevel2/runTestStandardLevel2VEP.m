%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP'; % Input data directory used for this demo
%outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
outdir = 'N:\\ARLAnalysis\\VEPStandardLevel2';
basename = 'vep';

pop_editoptions('option_single', false, 'option_savetwofiles', false);
lineFrequencies = [60, 120,  180, 212, 240];
referenceChannels = 1:64;
reReferencedChannels = 1:70;
%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    standardLevel2Pipeline;
    fprintf('Computation times (seconds): %g high pass, %g line noise, %g reference \n', ...
             computationTimes.highPass, computationTimes.lineNoise, ...
             computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end

