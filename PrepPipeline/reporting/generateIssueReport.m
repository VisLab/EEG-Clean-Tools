function report = generateIssueReport(EEG)
% Generates an issue report for an EEG structure that has been robustly referenced
aveCorrThreshold = 0.91;
medCorrThreshold = 0.95;
if nargin < 1
    error('generateIssueReport:NotEnoughArgs', ...
        'generateIssueReport requires an EEG structure argument');
end
report = '';

if ~isstruct(EEG)
    report = 'Input not an EEG structure';
    return;
end

nDetect = getFieldIfExists(EEG, {'etc', 'noiseDetection'});
if isempty(nDetect)
    report = 'Input EEG has not been robustly referenced';
    return;
end

status = getFieldIfExists(nDetect, {'errors', 'status'});
if ~isempty(status) && ~strcmpi(status, 'good');
    report = ['EEG referencing has following errors: [' ...
               getStructureString(nDetect.errors) ']'];
    return;
end

badChans = getFieldIfExists(nDetect, ...
    {'reference', 'noisyStatistics', 'noisyChannels' 'all'});
if ~isempty(badChans)
    report = [report ...
        sprintf('Noisy channels not interpolated after referencing: %s\n', ...
        getListString(badChans))];
end

evaluationChans = length(getFieldIfExists(nDetect, ...
    {'reference', 'noisyStatistics', 'evaluationChannels'}));
if 0.25*evaluationChans < length(badChans)
     report = [report sprintf('Data set has %d of %d EEG channels bad\n', ...
               length(badChans), evaluationChannels)];                      
end   


%% Median 
theCorr = getFieldIfExists(nDetect, ...
         {'reference', 'noisyStatistics', 'maximumCorrelations'});
if ~isempty(theCorr)
    meanCorr = mean(theCorr(:));
    medianCorr = median(theCorr(:));
    if meanCorr> aveCorrThreshold || medianCorr > medCorrThreshold
      report = [report ... 
          sprintf('Max win correlation [median=%g, mean=%g]\n', ...
                medianCorr, meanCorr)];
    end
end

devRef = getFieldIfExists(nDetect, ...
         {'reference', 'noisyStatistics', 'channelDeviations'});
devOrig = getFieldIfExists(nDetect, ...
         {'reference', 'noisyStatisticsOriginal', 'channelDeviations'});
if ~isempty(devRef) && ~isempty(devOrig)
   devRef = median(devRef(:));
   devOrig = median(devOrig(:));
   if devOrig < devRef
   report = [report  ...
        sprintf('Referencing did not improve amplitude [ref=%g, orig=%g]\n', ...
                devRev, devOrig)];
   end
end

