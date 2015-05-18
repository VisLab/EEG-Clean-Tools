function [] = showBadWindows(values, timeScales, colors, symbols,  ...
                     numberChannels, legendStrings, name, thresholdName)
% Display number of bad channels before and after referencing by window
verticalLabel = ['Number of channels (out of '  num2str(numberChannels) ')'];
tString = { name, ['Channels not meeting ' thresholdName ' threshold']}; 
figure('Name', tString{2}, 'Color', [1, 1, 1])
hold on
for k = 1:length(values)
   plot(timeScales{k}, values{k}, 'LineStyle', 'none', ...
       'Marker', symbols{k}, 'Color', colors(k,:)) 
end
hold off
xlabel('Seconds')
ylabel(verticalLabel);
legend(legendStrings(:)', ...
      'Location', 'SouthOutside', 'Orientation', 'Horizontal' )
title(tString, 'Interpreter', 'None');
box on
