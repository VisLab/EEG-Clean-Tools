function reportHighPass(noisyParameters, numbersPerRow, indent)
    if ~isfield(noisyParameters, 'highPass')
        fprintf('Signal wasn''t high pass filtered\n');
        return;
    end
    highPass = noisyParameters.highPass;
    fprintf('\n%sHigh pass filtering version %s\n', indent, ...
        noisyParameters.version.HighPass);      
    fprintf('%sHigh pass cutoff: %g Hz\n', indent, highPass.highPassCutoff);
    fprintf('%sFilter command:\n', indent, highPass.highPassFilterCommand);
    fprintf('%s%s%s\n', indent, indent, highPass.highPassFilterCommand);
    fprintf('%sHigh pass filtered channels:\n', indent);
    printList(highPass.highPassChannels, numbersPerRow, [indent, indent]);
end