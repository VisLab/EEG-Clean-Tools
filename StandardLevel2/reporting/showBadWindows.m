function [] = showBadWindows(beforeValues, afterValues, beforeTimeScale, ...
        afterTimeScale, numberChannels, legendStrings, name, thresholdName)
% Display number of bad channels before and after referencing by window
verticalLabel = ['Number of channels (out of '  num2str(numberChannels) ')'];
tString = { name, ['Channels not meeting ' thresholdName ' threshold']}; 
figure('Name', tString{2})
hold on
plot(beforeTimeScale, beforeValues, '+k')
plot(afterTimeScale, afterValues, 'or')
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend(legendStrings{1}, legendStrings{2}, ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');

