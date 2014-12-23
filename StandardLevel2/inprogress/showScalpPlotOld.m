function  [] = showScalpPlot(values, echans, chaninfo, msg)
% Display topoplot of values using channel locations given by echans
try
    amplitude = results.robustChannelDeviation(referenceChannels);
    tString = ['Robust channel deviation (' msg '): ' dname];
    figure('Name', tString)
    topoplot(amplitude, echans, 'style', 'map', ...
        'electrodes', 'ptslabels','chaninfo',chaninfo);
    title(tString, 'Interpreter', 'none')
    colorbar
catch mex
    warning(['Robust channel deviation ' dname ' topoplot failed: ' ...
        mex.message]);
end