function badFrameCount = getBadFrames(noisyStatistics, types, ...
                              evaluationChannels, srate, numberFrames)
% Get mask of frames from windows with more than specified # of bad channels
% 
% Calling sequence:
%    frameMask = getBadFrames(EEG, 10)
%
% Parameters:
%     noisyStatistics      Structure containing the noisy statistics
%     evaluationChannels   Channels at which to evaluate
%     srate                Sampling rate of the data
%     numberFrames         Length of the mask needed
%     badChannelThreshold - number of channels needed to be bad
%
%     badFrameCount - (output) vector of same size as number of frames in EEG with
%                 1's indicating bad frames and 0's indicating others
%
% The algorithm only uses deviation, correlation, or high frequency
% criteria

%% Get the relevant windows
   numberChannels = length(evaluationChannels);
   frameMask = false(numberChannels, numberFrames);
   for k = 1:length(types)
       frameMask = frameMask | getFrameMask(types{k});
   end
   badFrameCount = sum(frameMask);
   
   function badFrames = getFrameMask(badCriterion)
       [windows, seconds, threshhold] = getBadWindows(noisyStatistics, badCriterion); 
       windows = windows(evaluationChannels, :);
       framesPerWindow = seconds*srate;
       numberWindows = ...
           min(size(windows, 2), floor(numberFrames/framesPerWindow));
       remainingFrames = numberFrames - numberWindows*framesPerWindow;
       badFrames = repmat(windows > threshhold, 1, 1, framesPerWindow);
       badFrames = permute(badFrames, [3, 2, 1]);
       badFrames = ...
           reshape(badFrames, framesPerWindow*numberWindows, numberChannels)';
       if remainingFrames > 0
           badFrames = [badFrames  true(numberChannels, remainingFrames)];
       end
    end
end