function [uniqueEventTypes, boundaryEvents, hardEvents, hardFrames] = ...
                                            getBoundaryEvents(events)
% Returns the event types and boundary events for EEGLAB events structure
% (as extracted from EEG.event).
   uniqueEventTypes = [];
   boundaryEvents = [];
   hardEvents = [];
   hardFrames = [];
   if isempty(events)
       return;
   end
   types = cellfun(@num2str, {events.type}, 'UniformOutput', false);
   uniqueEventTypes = unique(types);
   boundaryMask = strcmpi(types, 'boundary');
   if sum(boundaryMask > 0) && isfield(events, 'duration')
        boundaryEvents = (1:length(events));
        boundaryEvents = boundaryEvents(boundaryMask);
        boundaryDurations = cell2mat({events(boundaryMask).duration}');
        hard = isnan(boundaryDurations);      
        if sum(hard) > 0
            hardEvents = boundaryEvents(hard);
            hardFrames = round(cell2mat({events(hardEvents).latency}));
        end
   end
end