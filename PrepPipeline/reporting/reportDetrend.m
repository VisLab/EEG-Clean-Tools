function summary = reportDetrend(fid, noiseDetection, numbersPerRow, indent)
% Outputs a summary of detrending/HP and returns a list. 
    summary = {};
    if isfield(noiseDetection.errors, 'detrend') && ...
            ~isempty(noiseDetection.errors.detrend)
        summary{end+1} =  noiseDetection.errors.detrend;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noiseDetection, 'detrend') || isempty(noiseDetection.detrend)
        summary{end+1} = 'Signal wasn''t detrended';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    detrendInfo = noiseDetection.detrend; 
    summary{end+1} = ['Detrend type: ', detrendInfo.detrendType];
    fprintf(fid, '%s\n', summary{end});
    fprintf(fid, 'Detrend cutoff: %g Hz\n', detrendInfo.detrendCutoff);  
    fprintf(fid, 'Detrend step size: %s\n', detrendInfo.detrendStepSize);
    fprintf('Detrend command:\n%s\n', detrendInfo.detrendCommand);
    fprintf(fid, 'Detrended channels (%d channels):\n', ...
            length(detrendInfo.detrendChannels));
    printListCompressed(fid, detrendInfo.detrendChannels, numbersPerRow, indent);
end