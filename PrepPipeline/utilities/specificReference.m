function referenceOut = specificReference(signal, referenceIn)
% Calculate the reference with respect to specific reference channels
referenceOut = referenceIn;
referenceChannels = referenceIn.referenceChannels;
if ~isempty(referenceChannels)
   referenceSignal = nanmean(signal.data(referenceChannels, :), 1);
else
   referenceSignal = zeros(1, size(signal.data, 2));
end
signalTmp = removeReference(signal, referenceSignal, referenceChannels);
referenceOut.noisyStatistics = findNoisyChannels(signalTmp, referenceIn);
referenceOut.referenceSignal = referenceSignal;
referenceOut.actualReferenceIterations = 1;

