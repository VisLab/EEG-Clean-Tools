function [] = outputPrepParams(params, theTitle, fd)
% Output params structure values
%
% Parameters:
%     params       Parameter structure
%     theTitle     String identifying the output
%     fd           (optional) Integer representing an open file descriptor.
%                  If omitted, outputs to the command window.

%% Check for defaults
    if nargin < 3
        fd = 1;
    end

    %% List the different pipeline step names
    pFields = fieldnames(params);
    fprintf(fd, '%s....\n', theTitle);
    for k = 1:length(pFields)
        %% Output the default parameter settings for each stage
        
        pValue = params.(pFields{k});
        if isstruct(pValue)
            valueStr = ['struct: ' convertCell2Str(fieldnames(pValue))];
        else
            valueStr = num2str(pValue);
        end
        fprintf(fd, '\t%s: [%s]\n', pFields{k}, valueStr);          
    end
