function [] = outputPrepDefaults(signal, fd)
% Output the defaults for each step in standard pipeline for a signal
%
% Parameters:
%     signal       A structure compatible with EEGLAB EEG structure
%                   (must have .data, .chanlocs, and .srate fields
%     fd           (optional) Integer representing an open file descriptor.
%                  If omitted, outputs to the command window.

%% Check for defaults
    if nargin < 2
        fd = 1;
    end

%% List the different pipeline step names
    defaultTypes = {'general', 'boundary', 'resample', 'detrend', ...
                    'globaltrend', 'linenoise', 'reference', ...
                    'report', 'postprocess'};
    fprintf(fd, 'PREP pipeline default settings....\n');
    for n = 1:length(defaultTypes)
        outputTheseDefaults(defaultTypes{n});
    end

    function outputTheseDefaults(thisType)
        %% Output the default parameter settings for each stage
        fprintf(fd, '\n....%s....:\n', thisType);
        defaults = getPrepDefaults(signal, thisType);
        params = struct();
        params = checkPrepDefaults(params, params, defaults);

        fNames = fieldnames(params);
        numFields = length(fNames);
        for k = 1:numFields
            dValue = defaults.(fNames{k});
            if isstruct(dValue.value)
               valueStr = ['struct: ' convertCell2Str(fieldnames(dValue.value))];
            else
               valueStr = num2str(dValue.value);
            end
            fprintf(fd, '\t%s: [%s]\n', fNames{k}, valueStr);
            fprintf(fd, '\t\t%s', dValue.description);
            if ~isempty(dValue.classes)
                fprintf(fd, '\n\t\t[classes: ');
                for m = 1:length(dValue.classes)
                    fprintf(fd, '%s ', num2str(dValue.classes{m}));
                end
                fprintf(']');
            end
            if ~isempty(dValue.attributes)
                fprintf(fd, '\n\t\t[attributes: ');
                for m = 1:length(dValue.attributes)
                    fprintf(fd, '%s ', num2str(dValue.attributes{m}));
                end
                fprintf(']');
            end
            fprintf(fd, '\n');
        end
    end

end
