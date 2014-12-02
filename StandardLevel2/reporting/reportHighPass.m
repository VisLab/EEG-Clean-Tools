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
    fprintf(fid, '\n%sHigh pass filtering version %s\n', indent, ...
        noisyParameters.version.HighPass);      
    fprintf(fid, '%sHigh pass cutoff: %g Hz\n', indent, highPass.highPassCutoff);
    fprintf('%sFilter command:\n%s%s%s\n', indent, indent, indent, ...
        highPass.highPassFilterCommand);
    fprintf(fid, '%sHigh pass filtered channels (%d channels):\n', ...
            indent, length(highPass.highPassChannels));
    printList(fid, highPass.highPassChannels, numbersPerRow, [indent, indent]);
end