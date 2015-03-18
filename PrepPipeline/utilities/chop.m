function [EEG, choppedFront, choppedBack] = chop(EEG, frontChop, backChop)
% Deletes all but specified seconds from outside first and last event
%
% This removes bad segments from the beginning and end of the data
% set, which often correspond to bad times for continuous EEG
%
% Parameters:
%    EEG = EEGLAB structure
%    frontChop = 
choppedFront = 0;
choppedBack = 0;
if size(EEG.data, 3) > 1
    warning('chop:DataNotContinuous', 'Only works on continuous data');
    return;
elseif nargin < 3
    error('chop:NotEnoughArguments', 'Requires 3 arguments');
elseif isempty(EEG.event)
    warning('chop:NoEvents', 'EEG has no events, so no chop is done');
    return;
end
srate = EEG.srate;
firstEventTime = double(EEG.event(1).latency - 1)/srate;
lastEventTime = double(EEG.event(end).latency - 1)/srate;
lastDataTime = double(EEG.pnts-1)/srate;
choppedFront = max(0, firstEventTime - frontChop);
endTime = min(lastDataTime, lastEventTime + backChop);
choppedBack = lastDataTime - endTime;
EEG = pop_select(EEG, 'time', [choppedFront, endTime]);
boundaryEvents = strcmpi({EEG.event.type}, 'boundary');
if sum(strcmpi(EEG.event(1).type, 'boundary')) > 0
    fprintf('Removing %g boundary events\n', sum(boundaryEvents));
    EEG.event(boundaryEvents) = [];
end