function msgString = getMessageString(messages)
% Returns a single string with the messages from cell array messages
if isempty(messages)
    msgString = '';
    return;
end;
msgString = num2str(messages{1});
for k = 2:length(messages)
    msgString = [msgString ' | ' num2str(messages{k})]; %#ok<AGROW>
end
