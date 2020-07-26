function [EEG, postOut] = prepPostProcess(EEG, postIn)
% PREP post-processing: HP filter, remove interpolated, cleanup metadata
%
%
% 
%% Setup the options for EEGLab to use double precision
    [backupOptionsFile, currentOptionsFile, warningsState] = setupForEEGLAB();
    finishup = onCleanup(@() cleanup(backupOptionsFile, currentOptionsFile, ...
        warningsState));

%% Check the parameters
postOut = struct();

%% Initial setup
    try
        %% Check the input
        if nargin < 1 || ~isstruct(EEG)
            error('postProcess:NotEnoughArguments', 'first argument must be a structure');
        elseif nargin < 2 || ~exist('postIn', 'var') || isempty(postIn)
            postIn = struct();
        end
        if ~isstruct(postIn)
            error('postProcess:NoData', 'second argument must be a structure')
        end
        if ~isfield(EEG, 'etc') || ~isfield(EEG.etc, 'noiseDetection') || ...
                hasPrepErrors(EEG.etc.noiseDetection)
            error('postProcess:NoPrep', 'Prep has not executed or has errors');
        end

        %% Set up the output structure
        postOut = struct('keepFiltered', [], 'removeInterpolatedChannels', [], ...
            'cleanupReference', []);
        defaults = getPrepDefaults(EEG, 'postprocess');

        [postOut, errors] = checkPrepDefaults(postIn, postOut, defaults);
        if ~isempty(errors)
            error('postProcess:BadParameters', ['|' sprintf('%s|', errors{:})]);
        end
        defaults = getPrepDefaults(EEG, 'general');
        [postOut, errors] = checkPrepDefaults(postOut, postOut, defaults);
        if ~isempty(errors)
            error('postProcess:BadGeneralParameters', ['|' sprintf('%s|', errors{:})]);
        end
        EEG.etc.noiseDetection.postProcess = postOut;

    catch mex
        errorMessages.setup = ...
            ['postProcessing failed due to previous issues: ' ...
            getReport(mex, 'basic', 'hyperlinks', 'off')];
        EEG.etc.noiseDetection.errors.postProcess = errorMessages;
        return;
    end
     
%% Perform filtering if requested
     try
        if postOut.keepFiltered
          fprintf('Refiltering the data in post processing\n');
          [EEG, detrend] = removeTrend(EEG, postOut);
          EEG.etc.noiseDetection.postProcess.detrend = detrend;
        end
    catch mex
        errorMessages.detrend = ...
            ['postProcessing failed removeTrend: ' ...
            getReport(mex, 'basic', 'hyperlinks', 'off')];
        EEG.etc.noiseDetection.errors.status = 'post-processing error';
        EEG.etc.noiseDetection.errors.postProcess = errorMessages;
        if strcmpi(postOut.errorMsgs, 'verbose')
            warning('[%s]\n%s', mex.identifier, ...
                getReport(mex, 'extended', 'hyperlinks', 'on'));
        end
        return;
     end

%% Remove interpolated channels if requested
     try
        interpolatedChannels = EEG.etc.noiseDetection.reference.interpolatedChannels.all;
        if postOut.removeInterpolatedChannels && ~isempty(interpolatedChannels)
          EEG.etc.noiseDetection.postProcess.removedChannelNumbers = ...
               interpolatedChannels; 
          EEG.etc.noiseDetection.postProcess.removedChannelData = ...
               EEG.data(interpolatedChannels, :);
          EEG.etc.noiseDetection.postProcess.removedChanlocs = ...
               EEG.chanlocs(interpolatedChannels);
          EEG.chanlocs(interpolatedChannels) = [];
          EEG.data(interpolatedChannels, :) = [];
          EEG.nbchan = length(EEG.chanlocs);                              
        else
           EEG.etc.noiseDetection.postProcess.removedChannelNumbers = [];
           EEG.etc.noiseDetection.postProcess.removedChannelLocs = [];
        end   
    catch mex
        errorMessages.removeInterpolated = ...
            ['postProcessing failed to remove interpolated channels: ' ...
              getReport(mex, 'basic', 'hyperlinks', 'off')];
        EEG.etc.noiseDetection.errors.status = 'post-processing error';
        EEG.etc.noiseDetection.errors.postProcess = errorMessages;
        if strcmpi(postOut.errorMsgs, 'verbose')
            warning('[%s]\n%s', mex.identifier, ...
                getReport(mex, 'extended', 'hyperlinks', 'on'));
        end
        return;
     end
     postOut = EEG.etc.noiseDetection.postProcess;

 %% Cleanup if requested
     try
        if postOut.cleanupReference
           EEG = cleanupReference(EEG);
        end
    catch mex
        errorMessages.cleanupReference = ...
            ['postProcessing failed to cleanup reference information: ' ...
            getReport(mex, 'basic', 'hyperlinks', 'off')];
        EEG.etc.noiseDetection.errors.status = 'post-processing error';
        EEG.etc.noiseDetection.errors.postProcess = errorMessages;
        if strcmpi(postOut.errorMsgs, 'verbose')
            warning('[%s]\n%s', mex.identifier, ...
                getReport(mex, 'extended', 'hyperlinks', 'on'));
        end
        return;
     end
     
     %% If we got this far everything was good
     EEG.etc.noiseDetection.errors.postProcess = 0;
end

%% Cleanup callback
function cleanup(backupFile, currentFile, warningsState)
% Restore EEGLAB options file and warning settings 
   restoreEEGOptions(backupFile, currentFile);
   warning(warningsState);
end % cleanup