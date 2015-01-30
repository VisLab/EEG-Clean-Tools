function summary = reportHighPass(fid, noiseDetection, numbersPerRow, indent)
% Outputs a summary to file fid and returns a cell array of important messages
    summary = {};
    if ~isempty(noiseDetection.errors.highPass)
        summary{end+1} =  noiseDetection.errors.highPass;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noiseDetection, 'highPass')
        summary{end+1} = 'Signal wasn''t high pass filtered';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    highPass = noiseDetection.highPass;
    fprintf(fid, '\nHigh pass filtering version %s\n', ...
        noiseDetection.version.HighPass);      
    fprintf(fid, 'High pass cutoff: %g Hz\n',highPass.highPassCutoff);
    fprintf('Filter command:\n%s\n', indent, highPass.highPassFilterCommand);
    fprintf(fid, 'High pass filtered channels (%d channels):\n', ...
            length(highPass.highPassChannels));
    printList(fid, highPass.highPassChannels, numbersPerRow, indent);
end