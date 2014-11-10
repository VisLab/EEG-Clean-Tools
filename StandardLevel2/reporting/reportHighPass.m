function summary = reportHighPass(fid, noisyParameters, numbersPerRow, indent)
% Outputs a summary to file fid and returns a cell array of important messages
    summary = cell(1, 0);
    if ~isfield(noisyParameters, 'highPass')
        summary{1} = 'Signal wasn''t high pass filtered\n';
        fprintf(fid, summary{1});
        return;
    end
    highPass = noisyParameters.highPass;
    fprintf(fid, '\n%sHigh pass filtering version %s\n', indent, ...
        noisyParameters.version.HighPass);      
    fprintf(fid, '%sHigh pass cutoff: %g Hz\n', indent, highPass.highPassCutoff);
    fprintf('%sFilter command:\n%s%s%s\n', indent, indent, indent, ...
        highPass.highPassFilterCommand);
    fprintf(fid, '%sHigh pass filtered channels:\n', indent);
    printList(fid, highPass.highPassChannels, numbersPerRow, [indent, indent]);
end