function reference = cleanupReference(reference)
% Removes reference statistics fields for passing to derived measures

fields = {};
if isfield(reference, 'badSignalsUninterpolated')
    fields{end + 1} = 'badSignalsUninterpolated'; 
end
if isfield(reference, 'referenceSignalOriginal')
    fields{end + 1} = 'referenceSignalOriginal'; 
end
if isfield(reference, 'referenceSignal')
    fields{end + 1} = 'referenceSignal'; 
end
if isfield(reference, 'noisyStatisticsOriginal')
    fields{end + 1} = 'noisyStatisticsOriginal';
end
if isfield(reference, 'noisyStatisticsBeforeInterpolation')
    fields{end + 1} = 'noisyStatisticsBeforeInterpolation'; 
end
if isfield(reference, 'noisyStatistics')
    fields{end + 1} = 'noisyStatistics';
end
reference = rmfield(reference, fields);
