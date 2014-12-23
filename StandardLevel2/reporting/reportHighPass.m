function summary = reportHighPass(fid, noisyParameters, numbersPerRow, indent)
% Outputs a summary to file fid and returns a cell array of important messages
    summary = {};
    if ~isempty(noisyParameters.errors.highPass)
        summary{end+1} =  noisyParameters.errors.highPass;
        fprintf(fid, '%s\n', summary{end});
    end
    if ~isfield(noisyParameters, 'highPass')
        summary{end+1} = 'Signal wasn''t high pass filtered';
        fprintf(fid, '%s\n', summary{end});
        return;
    end
    highPass = noisyParameters.highPass;
    fprintf(fid, '\nHigh pass filtering version %s\n', ...
        noisyParameters.version.HighPass);      
    fprintf(fid, 'High pass cutoff: %g Hz\n',highPass.highPassCutoff);
    fprintf('Filter command:\n%s\n', indent, highPass.highPassFilterCommand);
    fprintf(fid, 'High pass filtered channels (%d channels):\n', ...
            length(highPass.highPassChannels));
    printList(fid, highPass.highPassChannels, numbersPerRow, indent);
end