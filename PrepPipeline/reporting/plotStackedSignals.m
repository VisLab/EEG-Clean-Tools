function plotStackedSignals(g)
% Plot stacked view of individual element or window signals
%
% plotStackedSignals(g)
%
% Input:
%   g                 structure containing optional arguments:
%   signals           2-d signal data
%   channels          the bad channel signals
%   clippingon        is a boolean, which if true causes the individual
%                     signals to be truncated so that they appear inside
%                     the axes
%   clippingtolerance the clipping tolerance
%   colors            two rgb arrays consisting of the good and bad channel
%                     signals
%   signallabel       is a string identifying the units of the signal
%   signalscale       is a numerical factor specifying the vertical spacing
%                     of the individual line plots. The spacing is
%                     SignalScale times the 10% trimmed mean of the
%                     standard deviation of the data
%   srate             the sampling rate
%   timescale         the time scale
%   trimpercent       is a numerical value specifying the percentage of
%                     extreme points to remove from the window before
%                     plotting. If the percentage is t, the largest
%                     t/2 percentage and the smallest t/2 percentage of the
%                     data points are removed (over all elements or
%                     channels). The signal scale is calculated relative to
%                     the trimmed signal and all of the signals are clipped
%                     at the trim cutoff before plotting
%   titlestring       the title of the stacked signal figure
%

myFigure = figure('Name', 'Signal Stacked Plot');
mainAxes = axes('Parent', myFigure, ...
    'Box', 'on', 'ActivePositionProperty', 'Position', ...
    'Units', 'normalized', ...
    'YDir', 'reverse', ...
    'Tag', 'stackedSignalAxes', 'HitTest', 'on');
hold (mainAxes, 'on');
[g, data, numPlots, numPlotsMax, xValues, colors, signalLabel, ...
    xValueMax, xValueMin, plotSpacing, timeUnits] =  getDefaultValues(g);
plotAxes(g, mainAxes, numPlots, plotSpacing, data, xValues, colors);
setAxes(mainAxes, numPlotsMax, xValueMin, xValueMax, timeUnits, ...
    plotSpacing, signalLabel);
hold(mainAxes, 'off');

    function plotAxes(g, mainAxes, numPlots, plotSpacing, data, ...
            xValues, colors)
        % Plot signals and events if given
        for c = 1:length(g)
            plotSignals(g(c), mainAxes, numPlots{c}, plotSpacing, data{c}, ...
                xValues{c}, colors{c})
            if ~isempty(g(c).events)
                plotEvents(mainAxes, xValues{c}, g(c));
            end
        end
    end

    function [tempStruct, data, numPlots, numPlotsMax, xValues, colors, ...
            signalLabel, xValueMax, xValueMin, plotSpacing, timeUnits] ...
            =  getDefaultValues(g)
        % Create default structure and values
        fields = {'channels', 'clipping', 'clippingtolerance', ...
            'colors', 'events', 'signallabel', 'signalscale', ...
            'signals', 'srate', 'timescale', 'trimpercent'};
        plotSpacing = 0;
        data = cell(1, length(g));
        numPlots = cell(1, length(g));
        xValues = cell(1, length(g));
        colors = cell(1, length(g));
        signalLabel = '';
        timeUnits = 's';
        xValueMax = 0;
        xValueMin = 0;
        numPlotsMax = 0;
        tempStruct(length(g)) = createEmptyStruct(fields);
        for a = 1:length(g)
            [tempStruct(a).('channels')] = ...
                getStructureParameters(g(a), 'channels', []);
            [tempStruct(a).('clipping')] = ...
                getStructureParameters(g(a), 'clipping', 'on');
            [tempStruct(a).('clippingtolerance')] = ...
                getStructureParameters(g(a), 'clippingtolerance', 0.05);
            [tempStruct(a).('colors')] = ...
                getStructureParameters(g(a), 'colors', ...
                {[0.7, 0.7, 0.7], [1, 0, 0]});
            [tempStruct(a).('events')] = ...
                getStructureParameters(g(a), 'events', []);
            [tempStruct(a).('signallabel')] = ...
                getStructureParameters(g(a), 'signallabel', '{\mu}V');
            [tempStruct(a).('signalscale')] = ...
                getStructureParameters(g(a), 'signalscale', 3);
            [tempStruct(a).('signals')] = ...
                getStructureParameters(g(a), 'signals', []);
            [tempStruct(a).('srate')] = ...
                getStructureParameters(g(a), 'srate', 1);
            [tempStruct(a).('timescale')] = ...
                getStructureParameters(g(a), 'timescale', []);
            [tempStruct(a).('trimpercent')] = ...
                getStructureParameters(g(a), 'trimpercent', 0);
            [numPlots{a}, xValues{a}, timeUnits, data{a}, ...
                currentPlotSpacing, colors{a}] = ...
                calculateData(tempStruct(a));
            plotSpacing = max(plotSpacing, currentPlotSpacing);
            signalLabel = tempStruct(a).signallabel;
            xValueMin = min(xValues{a}(1), xValueMin);
            xValueMax = max(xValues{a}(end), xValueMax);
            numPlotsMax = max(numPlots{a},numPlotsMax);
        end
    end

    function emptyStruct = createEmptyStruct(fields)
        % Create an empty structure with given fields
        emptyStruct = [];
        for b = 1:length(fields)
            emptyStruct.(fields{b}) = [];
        end
    end

    function colors = getColors(g)
        % Returns the signal colors from the plot
        colors = repmat(g.colors{1}, [size(g.signals,1), 1]);
        for a = 1:length(g.channels)
            colors(g.channels(a),:) = g.colors{2};
        end
    end

    function [numPlots, xValues, timeUnits, data, plotSpacing, ...
            colors] = calculateData(g)
        % Plot the g.signals stacked one on top of another
        nSamples = size(g.signals, 2);
        xLimOffset = (1 - 1)*nSamples/g.srate;
        if ~isempty(g.timescale)
            timeUnits = 'ms';
            xValues = 1000*g.timescale;
        else
            timeUnits = 's';
            xValues = xLimOffset + ...
                (0:(size(g.signals, 2) - 1))/g.srate;
        end
        colors = getColors(g);
        data = g.signals;
        
        numPlots = size(g.signals, 1);
        if numPlots == 0
            warning('signalStackedPlot:NaNValues', ...
                'No g.signals to plot');
            return;
        end
        % Take care of trimming based on scope
        
        [tMean, tStd, tLow, tHigh] = ...
            getTrimValues(g.trimpercent, g.signals);
        
        
        scale = g.signalscale;
        if isempty(scale)
            scale = 1;
        end
        plotSpacing = double(scale)*tStd;
        if isnan(plotSpacing)
            warning('signalStackedPlot:NaNValues', ...
                'No g.signals to plot');
            return;
        end
        if plotSpacing == 0;
            plotSpacing = 0.1;
        end
        data(data < tLow) = tLow;
        data(data > tHigh) = tHigh;
        data = data - tMean;
    end % displayPlot

    function plotSignals(g, mainAxes, numPlots, plotSpacing, data, ...
            xValues, colors)
        %y-axis reversed, so must plot the negative of the g.signals
        lineWidthUnselected = 0.5;
        eps = plotSpacing*g.clippingtolerance;
        hitList = cell(1, numPlots + 1);
        hitList{1} = mainAxes;
        for k = 1:numPlots
            g.signals =  - data(k, :) + k*plotSpacing;
            if strcmpi(g.clipping, 'on')
                g.signals = min((numPlots + 1)*plotSpacing - eps, ...
                    max(eps, g.signals));
            end
            hp = plot(mainAxes, xValues, g.signals, ...
                'Color', colors(k, :), ...
                'Clipping',g.clipping, 'LineWidth', lineWidthUnselected);
            set(hp, 'Tag', num2str(k));
            hitList{k + 1} = hp;
        end
    end

    function setAxes(mainAxes, numPlotsMax, xValueMin, xValueMax, ...
            timeUnits, plotSpacing, signalLabel)
        % Set axes labels
        xStringBase = ['Channels 1:',num2str(numPlotsMax)];
        xString = ['Time(' timeUnits ') [' xStringBase ']'];
        xString = sprintf('%s (Scale: %g %s)', ...
            xString, plotSpacing, signalLabel);
        yString = 'Channel';
        yTickLabels = cell(1, numPlotsMax);
        yTickLabels{1} = '1';
        yTickLabels{numPlotsMax} = num2str(numPlotsMax);
        set(mainAxes,  'YLimMode', 'manual', ...
            'YLim', [0, plotSpacing*(numPlotsMax + 1)], ...
            'YTickMode', 'manual', 'YTickLabelMode', 'manual', ...
            'YTick', plotSpacing:plotSpacing:numPlotsMax*plotSpacing, ...
            'YTickLabel', yTickLabels, ...
            'XTickMode', 'auto', ...
            'XLim', [xValueMin, xValueMax], 'XLimMode', 'manual', ...
            'XTickMode', 'auto');
        xLab = get(mainAxes, 'XLabel');
        set(xLab, 'String', xString);
        yLab = get(mainAxes, 'YLabel');
        set(yLab, 'String', yString);
    end

    function plotEvents(mainAxes, xValues, g)
        % Plot events if given
        if ischar(g.events(1).type)
            [uniqueEventTypes, ~, indexcolor] = ...
                unique({g.events.type});
        else
            [uniqueEventTypes, ~, indexcolor] = ...
                unique([ g.events.type ]);
        end
        eventTypes = {g.events.type};
        eventColors = {[.25 1 0], [1 1 0], [.25 .75 .25],[.5 0 0], ...
            [1 0 1], [.5 0 .5], [.5 1 0], [.5 .5 0], [1 0 0], ...
            [.75 .25 .75], [.75 1 0],[0 1 0], [.75 .75 0], [.5 .5 .5], ....
            [.25 0 .25], [0 0 1], [.25 .25 .25], [0 1 1], [.5 .25 .75]};
        eventWidths = [ 2.5 1 ];
        eventColors = eventColors(mod(indexcolor-1, ...
            length(eventColors))+1);
        indexwidth = ones(1,length(uniqueEventTypes))*2;
        if iscell(uniqueEventTypes)
            for index = 1:length(uniqueEventTypes)
                if strcmpi(uniqueEventTypes{index}, 'boundary')
                    indexwidth(index) = 1;
                end
            end
        end
        eventWidths = eventWidths (mod(indexwidth(indexcolor)-1, ...
            length(eventWidths))+1);
        eventLatencies = [g.events.latency];
        if  isempty(g.timescale)
            eventLatencies = [g.events.latency] / 1000;
        end
        event2plot = find(eventLatencies >=xValues(1) & ...
            eventLatencies <= xValues(end));
        plotEvents = [];
        plotEventTypes = {};
        for index = 1:length(event2plot)
            tmplat = eventLatencies(event2plot(index));
            tmph = plot(mainAxes, [ tmplat tmplat ], ylim, 'color', ...
                eventColors{event2plot(index)}, ...
                'linewidth', eventWidths( event2plot(index) ) );
            if ~elementExists(plotEventTypes, ...
                    num2str(eventTypes{event2plot(index)}))
                plotEvents(end+1) = tmph; %#ok<AGROW>
                plotEventTypes{end+1} = ...
                    num2str(eventTypes{event2plot(index)}); %#ok<AGROW>
            end
        end
        if ~isempty(plotEvents) && ~isempty(plotEventTypes)
            legend(plotEvents, plotEventTypes);
        end
    end % plotEvents

    function elementExists = elementExists(array, element)
        % Checks if element is in a array
        elementExists = false;
        for a = 1:length(array)
            if strcmpi(array{a}, element)
                elementExists = true;
                return;
            end
        end
    end % elementExists

    function [tMean, tStd, tLow, tHigh] = getTrimValues(percent, data)
        % Return trim mean, trim std, trim low cutoff, trim high cutoff
        myData = data(:);
        if isempty(percent) || percent <= 0 || percent >= 100
            tLow = min(myData);
            tHigh = max(myData);
        else
            tValues = prctile(myData, [percent/2, 100 - percent/2]);
            tLow = tValues(1);
            tHigh = tValues(2);
            myData(myData < tLow | myData > tHigh) = [];
        end
        tMean = mean(myData);
        tStd = std(myData, 1);
    end % getTrimValues

end % plotStackedSignals
