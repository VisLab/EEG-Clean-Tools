function [] = outputPrepErrors(noiseDetection, theTitle, fd)
% Output params structure values
%
% Parameters:
%     noiseDetection   Structure containing the error messages
%     theTitle         String identifying the output
%     fd               (optional) Integer representing an open file descriptor.
%                      If omitted, outputs to the command window.

%% Check for defaults
    if nargin < 3
        fd = 1;
    end

%% Make sure that noiseDetection has an errors field
    if isempty(noiseDetection) || ~isstruct(noiseDetection) || ~isfield(noiseDetection, 'errors')
        fprintf(fd, 'Prep pipeline was not executed --- no errors field\n');
        return;
    end
    errors = noiseDetection.errors;
    
%% List the different pipeline step names
    fprintf(fd, '\n%s....', theTitle);
    if isfield(errors, 'status')
        fprintf(fd, 'Status: %s', errors.status);
    end
    fprintf('\n');
    outputErrorField('boundary');
    outputErrorField('detrend');
    outputErrorField('lineNoise');
    outputErrorField('reference');
    outputErrorField('postProcess');
    
%% Output the status
    function outputErrorField(fieldName)
        if ~isfield(errors, fieldName)
            theError = 'Not performed';
        elseif isnumeric(errors.(fieldName))
            theError = 'No errors';
        elseif isstruct(errors.(fieldName))
            theError = struct2str(errors.(fieldName));
        else
            theError = convertCell2Str(errors.(fieldName));
        end
        fprintf(fd, '\t%s: %s\n', fieldName, theError);
    end
end