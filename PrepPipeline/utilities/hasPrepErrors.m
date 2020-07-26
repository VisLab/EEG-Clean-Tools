function hasErrors = hasPrepErrors(noiseDetection)
% Return false if Prep has executed successfully
%
% Parameters:
%     noiseDetection   Structure containing prep execution information
%     hasErrors        (output) true if Prep did not execute or has errors

%% Check for defaults
   hasErrors = false;
%% Make sure that noiseDetection has an errors field
    if isempty(noiseDetection) || ~isstruct(noiseDetection) ||...
        ~isfield(noiseDetection, 'errors') || ...
        ~isstruct(noiseDetection.errors)
        hasErrors = true;
        return;
    end
    errors = noiseDetection.errors;
    errors = rmfield(errors, 'status');
    errorFields = fieldnames(errors);
    for k = 1:length(errorFields)
        if errors.(errorFields{k}) ~= 0
            hasErrors = true;
            break;
        end
    end
