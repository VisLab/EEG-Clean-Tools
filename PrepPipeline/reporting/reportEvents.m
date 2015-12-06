function [summary, hardFrames] = reportEvents(fid, EEG)
% Outputs a summary of line noise removal to file fid and returns a cell array of important messages
    hardFrames = [];
    if ~isfield(EEG, 'event') || isempty(EEG.event)
        summary = {'Events: dataset has no events'};
        return;
    else
        summary = {};
    end
    summary{end+1} = ['Events: ' num2str(length(EEG.event)) ...
                      ', Original events: ' num2str(length(EEG.urevent))];
    fprintf(fid, '%s\n', summary{end});  
    if isfield(EEG.event, 'hedtags')
        summary{end+1} = 'Data set uses hedtags';
    end
    if isfield(EEG.event, 'usertags')
        summary{end+1} = 'Data set uses usertags';
    end
   
    [uniqueEventTypes, boundaryEvents, hardEvents, hardFrames] = ...
                                            getBoundaryEvents(EEG.event);
    fprintf(fid, 'Unique event types: %d\n', length(uniqueEventTypes));
    if ~isempty(boundaryEvents)
        summary{end+1} = ['Boundary events: ' ...
            num2str(length(boundaryEvents)) ', Hard boundary events: ' ...
            num2str(length(hardEvents))];          
        fprintf(fid, '%s\n', summary{end});      
        if ~isempty(hardEvents)
            fprintf(fid, 'Hard boundary events: ');
            printList(fid, hardEvents, 10, '   ');
            fprintf(fid, 'Hard frame numbers: ');
            printList(fid, hardFrames, 10, '   ');
        end
    end
end

