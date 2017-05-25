function summary = reportGlobalDetrend(fid, noiseDetection, numbersPerRow, indent)
% Outputs a summary of global trend removal to file fid and returns a cell array of important messages
    summary = {};
    if isfield(noiseDetection.errors, 'globalTrend') && ...
        ~isempty(noiseDetection.errors.globalTrend)
        summary{end+1} =  noiseDetection.errors.globalTrend;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noiseDetection, 'globalTrend') || isempty(noiseDetection.globalTrend)
        summary{end+1} = 'Signal didn''t have global trend removed';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    globalTrend = noiseDetection.globalTrend;
    summary{end+1} = sprintf(['Absolute channel correlation [mean = %g' ...
         ' median=%g, sd=%g]'], ...
         mean(abs(globalTrend.channelCorrelations)), ...
         median(abs(globalTrend.channelCorrelations)), ...
         std(abs(globalTrend.channelCorrelations)));
    fprintf(fid, '%s\n', summary{end});
    fprintf(fid, 'Global trend channels (%d channels):\n', ...
        length(globalTrend.globalTrendChannels));
    printList(fid, globalTrend.globalTrendChannels, numbersPerRow, indent);
end

