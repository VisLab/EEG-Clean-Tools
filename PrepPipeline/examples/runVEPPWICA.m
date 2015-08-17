%% Example: Running the pipeline outside of ESS

%% Read in the file and set the necessary parameters
basename = 'vep';
basenameOut = 'vepReduced';
pop_editoptions('option_single', false, 'option_savetwofiles', false);
indir = 'O:\\ARL_Data\\VEP\\VEP_Robust_1Hz_Filtered';
outdir = 'O:\\ARL_Data\\VEP\\VEP_Robust_1Hz_Filtered_PWCICA';
params = struct();

%% Run the pipeline
for k = 1:18
    tic
    thisName = sprintf('%s_%02d', basename, k);
    fname = [indir filesep thisName '.set'];
    EEG = pop_loadset(fname);
    referenceChannels = EEG.etc.noiseDetection.reference.referenceChannels;
    interpolatedChannels = EEG.etc.noiseDetection.reference.interpolatedChannels.all;
    channelsLeft = setdiff(referenceChannels, interpolatedChannels);
    EEG.data = EEG.data(referenceChannels, :);
    EEG.chanlocs = EEG.chanlocs(referenceChannels);
    EEG.nbchan = length(referenceChannels);
    [W, EEG.etc.icametas] = pwcica(EEG.data, 'SamplingRate', EEG.srate, ...
                              'TimeInvariant', 0, 'Level', 16);
    scaling = repmat(sqrt(mean(inv(W).^2))',[1 size(W,1)]);
    display('Scaling components to RMS microvolt');
    W = scaling.*W;
    EEG.icaweights = W;
    EEG.icasphere = eye(size(EEG.data,1));
    EEG.icawinv = inv(W);
    EEG.setname = [thisName  'Robust 1Hz filtered ICA pwcica-(16)']; 
    thisName = sprintf('%s_%02d', basenameOut, k);
    outfname = [outdir filesep thisName '.set'];
    etc = EEG.etc;
    etc = rmfield(etc, 'noiseDetection');
    EEG.etc = etc;
    save(outfname, 'EEG', '-v7.3');
    elapsedTime = toc;
    fprintf('%d: %7.2f seconds\n', k, elapsedTime);
end
