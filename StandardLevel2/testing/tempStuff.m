

%% Construct new EEG with interpolated channels to find better average reference
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels) 
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
else
    signalTmp = signal;
end
referenceSignal = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
signalTmp = removeReference(signal, referenceSignal, ...
                                 referenceOut.rereferencedChannels);
%% Construct new EEG with interpolated channels to find better average reference
noisyChannels = union(noisyOutHuber.noisyChannels, unusableChannels);
if referenceOut.referenceChannels - length(noisyChannels) < 2
    error('Could not perform a robust reference -- not enough good channels');
elseif ~isempty(noisyChannels) 
    sourceChannels = setdiff(referenceOut.referenceChannels, noisyChannels);
    signalTmp = interpolateChannels(signal, noisyChannels, sourceChannels);
else
    signalTmp = signal;
end
referenceSignal = mean(signalTmp.data(referenceOut.referenceChannels, :), 1);
signalTmp = removeReference(signal, referenceSignal, ...
                                 referenceOut.rereferencedChannels);