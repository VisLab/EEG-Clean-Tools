function msgString = getMessageString(messages)
% Returns a single string with the messages from cell array messages
msgString = '';
for k = 1:length(messages)
    msgString = [msgString ' | ' messages{k}]; %#ok<AGROW>
end
