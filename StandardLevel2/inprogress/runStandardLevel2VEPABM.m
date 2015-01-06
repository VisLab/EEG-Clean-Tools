%% Read in the file and set the necessary parameters
indir = 'E:\\CTAData\\VEP_ABM'; % Input data directory used for this demo
%outdir = 'N:\\ARLAnalysis\\VEPABMStandardLevel2A';
outdir = 'N:\\ARLAnalysis\\VEPABMOrdinaryLevel2A';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
basename = 'A';

%% Run the pipeline
for k = 1:18
    thisName = sprintf('%s_%02d', basename, k);  
    fname = [indir filesep thisName '_VEP.set'];
    try
       EEG = pop_loadset(fname);
    catch mex
        continue;
    end
    chans = 1:length(EEG.chanlocs);
    params = struct();
    params.name = thisName;
    params.lineFrequencies = [60, 120,  180, 212, 240];
    params.referenceChannels = chans(~strcmpi('EKG', {EEG.chanlocs.labels}));
    labels = {EEG.chanlocs.labels};
    labels = labels(params.referenceChannels);
    printLabeledList(1, params.referenceChannels, labels, 10, '')
    params.rereferencedChannels = params.referenceChannels;
    params.highPassChannels = params.referenceChannels;
    params.lineNoiseChannels = params.referenceChannels;
    [EEG, computationTimes] = ordinaryLevel2Pipeline(EEG, params);
    fprintf('Computation times (seconds): %g high pass, %g resampling, %g line noise, %g reference \n', ...
        computationTimes.highPass, computationTimes.resampling, ...
        computationTimes.lineNoise, computationTimes.reference);
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end
