function plotScalpMap(data, chanlocs, interpolation, showColorbar, ...
    headColor, elementColor, clim, nosedir, titleString)
% Plots the scalp map with color bar and electrodes
%
% plotScalpMap(data, chanlocs, interpolation, showColorbar, headColor, ...
% elementColor, titleString)
%
% Input:
%   data            channel data vector
%   chanlocs        channel locations
%   interpolation   method of interpolation              
%   showColorbar    indicates whether to show colorbar
%   headColor       color for plotting the head
%   elementColor    electrode color
%   nosedir         ['+X'|'-X'|'+Y'|'-Y'] direction of nose {default: '+X'}
%   titleString     title of the scalp map figure
%
% This function calls MATLAB's underlying griddata function. The methods of
% interpolation are linear, cubic, natural, nearest, and v4. The function
% is based on code from EEGLAB and EEGVIS.

colorbarAxes = [];
numberElements = length(data);
startElement = 1;
headRadius = 0.5;
[validElements, interpolationRadius, plotRadius, ...
    squeezeFactor, x, y, labels, values] = ...
    findLocations(startElement, headRadius, chanlocs, ...
    data);
myFigure = figure('Name', titleString, 'Color', [1, 1, 1]);
mainAxes = axes('Parent', myFigure, ...
    'Box', 'on',  'ActivePositionProperty', 'Position', ...
    'Units', 'normalized', 'Tag', 'MainAxes');
bColor = get(myFigure, 'Color');
set(mainAxes, 'Color', 'none', 'XTick', [], 'yTick', [], ...
    'Box', 'off', 'XColor', bColor, 'YColor', bColor, 'ZColor', bColor);
set(get(mainAxes, 'XLabel'), 'Color', [0, 0, 0]);
headAxes = axes('Parent', ...
    get(mainAxes, 'Parent'), 'Tag', 'blockScalpHeadAxes', ...
    'ActivePositionProperty', 'Position', ...
    'Units', 'Normalized');
hold (headAxes, 'on');
plotMap(headAxes, validElements, headRadius, ...
    squeezeFactor, plotRadius, x, y, values, ...
    interpolationRadius, interpolation, nosedir, clim);
plotHead(headAxes, bColor, headRadius, ...
    squeezeFactor, headColor);
plotElements(x, y, labels, validElements, ...
    startElement, numberElements, elementColor, headColor);
hold (headAxes, 'off')
axis(headAxes, 'off')
set(myFigure, 'CurrentAxes', mainAxes);
redraw(myFigure, headAxes, mainAxes, colorbarAxes, showColorbar);

    function [validElements, interpolationRadius, plotRadius, ...
            squeezeFactor, x, y, labels, values] = ...
            findLocations(startElement, headRadius, elementLocs, ...
            bValues)
        % Find channels with valid locations and set scaled locations
        x = []; y = []; labels = {}; values = [];
        squeezeFactor = 1;
        interpolationRadius = 1;
        plotRadius = 1;
        validElements = [];
        if isempty(elementLocs)   % element locations not defined
            return;
        end
        validElements = find(~cellfun('isempty', {elementLocs.theta}));
        tempValidElements = intersect(find(~cellfun('isempty', {elementLocs.X})), ...
            validElements);
        badElements = union(find(isnan(bValues)), find(isinf(bValues))); % NaN and Inf values
        if ~isempty(badElements)
            validElements = setdiff(validElements, ...
                badElements + startElement - 1);
        end
        if isempty(validElements)
            return;
        end
        tempValidElements = sort(tempValidElements);
        theta = {elementLocs.theta};
        theta = pi/180*cell2mat(theta(tempValidElements));
        radius = {elementLocs.radius};
        radius = cell2mat(radius(tempValidElements));
        
        % Transform electrode locations from polar to cartesian coordinates
        [x, y] = pol2cart(theta, radius);
        labels = {elementLocs.labels};
        labels = char(labels(tempValidElements));
        values = bValues(tempValidElements);
        interpolationRadius = min(1.0, max(radius)*1.02); % just outside outermost electrode location
        plotRadius = max(interpolationRadius, 0.5);   % plot to 0.5 head boundary
        squeezeFactor = headRadius/plotRadius;
        validElements = tempValidElements;
        x = x*squeezeFactor;
        y = y*squeezeFactor;
    end % findLocations

    function markerSize = getMarkerSize(ylen)
        % Determine the marker size based on the number of electrodes
        mSizes = [10, 3, 4, 5, 6, 8];
        mCutoffs = [100, 80, 64, 48, 32];
        markerSize = mSizes(1);
        for k = 1:length(mCutoffs)
            if ylen > mCutoffs(k)
                markerSize = mSizes(k + 1);
                break;
            end
        end
    end % getMarkerSize

    function labelCallback (src, ~, textobj, labels)
        % Callback for switching string of textobj among labels on click
        labelNum = get(src, 'userdata');
        labelNum = mod(labelNum, length(labels)) + 1;
        set(textobj, 'String', labels{labelNum});
        set(src, 'userdata', labelNum);
    end % labelCallback

    function plotElements(x, y, labels, validElements, ...
            startElement, numberElements, elementColor, headColor)
        % Plot elements points and positions on current axes, setting callbacks
        if isempty(x)  % don't plot anything if no elements
            return;
        end
        
        mSize = getMarkerSize(length(x));
        elements = intersect(validElements, ...
            startElement:(startElement + numberElements - 1));
        elementMask = false(length(x), 1);
        elementMask(elements) = true;
        sliceElectrodes = cell(1, length(elements));
        sPos = 1;   % indexing variable
        for k = 1:length(x)
            if elementMask(k)    % Element in the slice
                sliceElectrodes{sPos} = ...
                    plot3(y(k), x(k), 2.1, '.', 'Color', elementColor, ...
                    'markersize', mSize, 'Tag', num2str(k));
                % Element labels switch
                h = text(double(y(k)+0.01),double(x(k)),...
                    2.1, labels(k,:),'HorizontalAlignment','left',...
                    'VerticalAlignment','middle','Color', elementColor, ...
                    'userdata', 1 , ...
                    'FontSize', get(0,'DefaultAxesFontSize'));
                set(h, 'ButtonDownFcn', {@labelCallback, h, ...
                    {num2str(validElements(k)), labels(k,:)}});
                sPos = sPos + 1;
            else
                h = text(double(y(k)+0.01),double(x(k)),...
                    2.1, '','HorizontalAlignment','left',...
                    'VerticalAlignment','middle','Color', headColor, ...
                    'FontSize', get(0,'DefaultAxesFontSize'));
                plot3(y(k), x(k), 2.1, '.', 'Color', headColor, ...
                    'markersize', mSize, 'userdata', 1, 'Tag', num2str(k), ...
                    'ButtonDownFcn', {@labelCallback, h, ...
                    {'', num2str(validElements(k)), labels(k,:)}});
            end
        end
    end % plotElements

    function plotHead(headAxes, backgroundColor, headRadius, squeezeFactor, headColor)
        % Plot head outline on current axes and label the graph
        
        % Plot filled ring to mask jagged grid boundary
        hwidth = 0.007;                         % cartoon head ring width
        hin  = squeezeFactor*headRadius*(1 - hwidth/2); % inner head ring radius
        rwidth = 0.035;                         % blanking ring width
        rin = max(hin, headRadius*(1 - rwidth/2));   % inner ring radius
        
        % Mask the outer circle
        circ = linspace(0, 2*pi, 201);         % create a circular grid
        rx = sin(circ);
        ry = cos(circ);
        ringx = [[rx(:)' rx(1) ]*(rin + rwidth)  [rx(:)' rx(1)]*rin];
        ringy = [[ry(:)' ry(1) ]*(rin + rwidth)  [ry(:)' ry(1)]*rin];
        patch(ringx, ringy, 0.01*ones(size(ringx)), ...
            backgroundColor, 'edgecolor', 'none'); %hold on
        
        % Plot head outline
        headx = [[rx(:)' rx(1) ]*(hin + hwidth)  [rx(:)' rx(1)]*hin];
        heady = [[ry(:)' ry(1) ]*(hin + hwidth)  [ry(:)' ry(1)]*hin];
        patch(headx, heady, ones(size(headx)), ...
            headColor, 'edgecolor', headColor); %hold on
        
        % Plot ears and nose
        base  = headRadius - 0.0046;
        basex = 0.18*headRadius;              % nose width
        tip   = 1.15*headRadius;
        tiphw = 0.04*headRadius;              % nose tip half width
        tipr  = 0.01*headRadius;              % nose tip rounding
        earX = [0.492, 0.510, 0.518, 0.5299, 0.5419, 0.54, 0.547, ...
            0.532, 0.510, 0.484];                % head radius = 0.5
        earY = [0.0955, 0.1175, 0.1183, 0.1146, 0.0955, -0.0055, ...
            -0.0932, -0.1313, -0.1384, -0.1199];
        
        plot3([basex; tiphw; 0; -tiphw; -basex]*squeezeFactor, ... % nose
            [base; tip - tipr; tip; tip - tipr; base]*squeezeFactor,...
            2*ones(size([basex; tiphw; 0; -tiphw; -basex])),...
            'Color', headColor, 'LineWidth', 1.7);
        plot3(earX*squeezeFactor, earY*squeezeFactor, ... % left ear
            2*ones(size(earX)), 'Color', headColor, 'LineWidth', 1.7)
        plot3(-earX*squeezeFactor, earY*squeezeFactor,  ... % right ear
            2*ones(size(earY)), 'Color', headColor, 'LineWidth', 1.7)
        
        set(headAxes, 'XTick', [], 'YTick', [], 'ZTick', []);
        %box on
        set(headAxes, 'xlim', [-0.51 0.51], 'ylim', [-0.51 0.51]);
    end % plotHead


    function plotMap(headAxes, validElements, headRadius, ...
            squeezeFactor, plotRadius, x, y, values, ...
            interpolationRadius, interpolation, nosedir, clim)
        % Plot contour map image on current axes for interpolation electrodes
        if isempty(values)  % Nothing to plot
            return;
        end
        
        % Find the elements to interpolate
        values = reshape(values, size(x)); % Make sure same dimensions
        intElements = find(x <= interpolationRadius & ...
            y <= interpolationRadius & ...
            ~isempty(values) & ~isnan(values));
        intElements = intersect(validElements, intElements);
        intx  = x(intElements);
        inty  = y(intElements);
        [intx, inty] = rotateChannels(nosedir, intx, inty);
        intValues = values(intElements);
        
        xmin = min(-headRadius, min(intx));
        xmax = max(headRadius, max(intx));
        ymin = min(-headRadius, min(inty));
        ymax = max(headRadius, max(inty));
        
        xLin = linspace(xmin, xmax, 67);
        yLin = linspace(ymin, ymax, 67);
        
        [Xi, Yi, Zi] = griddata(inty, intx, intValues, yLin', xLin, ...
            interpolation);  % interpolate
        
        mask = (sqrt(Xi.^2 + Yi.^2) > headRadius); % mask outside the plotting circle
        Zi(mask)  = NaN;                 % mask non-plotting areas
        delta = xLin(2) - xLin(1); % length of grid entry
        
        % instead of default larger AXHEADFAC
        AXHEADFAC = 1.3;        % head to axes scaling factor
        if squeezeFactor < 0.92 && plotRadius-headRadius > 0.05  % (size of head in axes)
            AXHEADFAC = 1.05;     % do not leave room for external ears if head cartoon
        end
        set(headAxes, ...
            'Xlim', [-headRadius headRadius]*AXHEADFAC, ...
            'Ylim', [-headRadius headRadius]*AXHEADFAC);
        surf(headAxes, Xi' - delta/2, Yi' - delta/2, zeros(size(Zi)), ...
            Zi', 'EdgeColor', 'none', 'FaceColor', 'flat');
        % set clim
        set(headAxes, 'CLim', clim);
    end % plotMap

    function redraw(myFigure, headAxes, mainAxes, colorbarAxes, showColorbar)
        redrawLayout(myFigure, mainAxes);
        % Redraws the axes in the figure 
        minimumGaps = [15, 15, 15, 15];  % smallest standard borders
        marginLeft = 10;           % pixels on left panel border
        marginRight = 10;          % pixels on right panel border
        if ~isempty(headAxes)
            oldUnitsHead = get(headAxes, 'Units');
            oldUnitsMain = get(mainAxes, 'Units');
            % Work in pixels
            set(headAxes, 'Units', 'Pixels');
            set(mainAxes, 'Units', 'Pixels');
            mainPos = get(mainAxes, 'Position');
            overallWidth = mainPos(3) + marginLeft + marginRight;
            workingMargin = max(marginLeft, marginRight);
            workingWidth = overallWidth - 2*workingMargin;
            
            % Account for a colorbar if it fits
            cWidth = 0;
            barWidth = 0;
            if (showColorbar)
                if isempty(colorbarAxes)
                    colorbarAxes = colorbar('peer', headAxes);
                    oldUnitsColor = get(colorbarAxes, 'Units');
                end
%                 set(colorbarAxes, 'ActivePositionProperty', 'Position', ...
%                     'Units', 'pixels');
                set(colorbarAxes, 'Units', 'pixels');
%                 cPosAll = get(colorbarAxes, 'TightInset');
                cPosAll = get(colorbarAxes, 'position');
                if minimumGaps(3) + cPosAll(3) + mainPos(4) > workingWidth
                    colorbar(colorbarAxes, 'off');
                    colorbarAxes = [];
                else
                    barWidth = get(colorbarAxes, 'Position');
                    barWidth = barWidth(3);
                    cWidth = cPosAll(3) + minimumGaps(3);
                end;
            end
            
            % Adjust the head axis
            headX = min(workingWidth - cWidth, mainPos(4));
            headPos = [(overallWidth - headX - cWidth)/2, mainPos(2), ...
                headX, mainPos(4)];
            set(headAxes, 'Position', headPos)
            
            % Set positions of colorbar and x label
            if ~isempty(colorbarAxes)
                set(colorbarAxes, 'Position', ...
                    [headPos(1) + headPos(3) + minimumGaps(3), ...
                    mainPos(2), barWidth, mainPos(4)]);
                set(colorbarAxes, 'Units', oldUnitsColor);
            end
            xLab = get(mainAxes, 'XLabel');
            set(xLab, 'Units', 'Pixels')
            xExtent = get(xLab, 'Extent');
            set(xLab, 'Position', ...
                [headPos(1) + headPos(3)/2 - mainPos(1), ...
                xExtent(4) - mainPos(2)]);
            
            % Restore the original units
            set(headAxes, 'Units', oldUnitsHead);
            set(mainAxes, 'Units', oldUnitsMain);
        end
    end % redraw

    function redrawLayout(myFigure, mainAxes)
        % Redraw the layout, positioning the children
        if isempty( myFigure ) || ~ishandle( myFigure )
            return
        end
        borderWidth = 1;
        padding = 0;
        xString = '';
        xLabelOffset = 0;
        yString = '';
        yLabelOffset = 0;
        marginBottom = 10;         % pixels on bottom panel border
        marginLeft = 10;           % pixels on left panel border
        marginRight = 10;          % pixels on right panel border
        marginTop = 10;            % pixels on top panel border
        % Selected one inherits visibility of layout and
        % fills the available space
        pos = getpixelposition(myFigure);
        border = borderWidth + 1 + padding;
        w = pos(3) - 2*border;
        h = pos(4) - 2*border;
        set(mainAxes, 'Units', 'Pixels')
        x0 = marginLeft;
        y0 = marginBottom;
        % Height and width of the axes must be at least 1 pixel
        w = max(1, w - marginLeft - marginRight);
        h = max(1, h - marginBottom - marginTop);
        set(mainAxes, 'Position', [x0, y0, w, h]);
        % Reposition labels if necessary
        yLab = get(mainAxes, 'YLabel');
        
        set(yLab, 'String', yString, 'Units', 'pixels', ...
            'Position', [-yLabelOffset, round(h/2)]);
        xLab = get(mainAxes, 'XLabel');
        set(xLab, 'String', xString, 'Units', 'pixels', ...
            'Position', [round(w/2), -xLabelOffset]);
    end % redrawLayout

    function [intx, inty] = rotateChannels(nosedir, intx, inty)
        % rotate channels based on chaninfo
        if strcmpi(nosedir, '+x')
            rotate = 0; %#ok<NASGU>
        else
            if strcmpi(nosedir, '+y')
                rotate = 3*pi/2;
            elseif strcmpi(nosedir, '-x')
                rotate = pi;
            else rotate = pi/2;
            end;
            allcoords = (inty + intx*sqrt(-1))*exp(sqrt(-1)*rotate);
            intx = imag(allcoords);
            inty = real(allcoords);
        end;
    end % rotateChannels

end % plotScalpMap