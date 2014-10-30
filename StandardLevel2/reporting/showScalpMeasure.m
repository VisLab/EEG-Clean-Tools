function showScalpMeasure(measure, channelLocations, nosedir, msg, scale)
    if nargin < 4 || ~exist('scale', 'var')
        scale = max(abs(measure));
    end
    headColor = [0.7, 0.7, 0.7];
    elementColor = [0, 0, 0];
%     [echans1, chaninfo1, refchans1] = getChannelInformation(report1);
%     [echans2, chaninfo2, refchans2] = getChannelInformation(report2);
%   
%     % Plot the robust channel deviation after rereferencing
%     results1 = report1.results;
%     results2 = report2.results;
    try
        tString1 = 'Robust channel deviation';
        plotScalpMap(measure, channelLocations, 'cubic', 1, headColor, ...
             elementColor, [-scale, scale], nosedir, msg);
    catch mex
        warning(['Robust channel map plot failed: ' mex.message]);
    end

end

