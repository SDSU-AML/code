function [ info ] = beautifyPlot( figH, axisH, traceH, legendH, titleH, xH, yH, xLims, yLims)
%BEAUTIFYPLOT Used to set line widths, markers, etc. for linear plots.
%   Can have legendH or titleH set to [] if nothing is to be done with
%   them.

    info = []; % Not currently used, but could alert user of errors
    lineWidth = 3;
    gray = [0.5 0.5 0.5];
    markerSize = 6;
    prefMarkers = {'none', 'o', '^', 'x'};
    prefLineStyles = {'-','--','-.',':'};
    axisLabelFontSize = 20;
    axesFontSize = 16;
    titleFontSize = 20;
    % titleFontSize = 20; % No title
    bandLineStyle = '-.';

    set(figH,'position',[200 200 1200 800]);
    set(figH,'color',[1 1 1]);
    set(axisH,'box','on');
   
    % Init for marker/styles
    count = 1;
    lineStyleCount = 1;
    for i = 1:length(traceH)
        % For the line itself (no markers)
        set(traceH(i),'color',[0 0 0]);
        set(traceH(i),'linewidth',lineWidth);
        set(traceH(i),'marker', prefMarkers{count});
        set(traceH(i),'markersize',markerSize);
        set(traceH(i),'linestyle',prefLineStyles{lineStyleCount});
        set(traceH(i),'markerfacecolor',[0 0 0]); % black
        set(traceH(i),'markeredgecolor',[0 0 0]); % black
        
        % The following will keep the same line style and change the marker
        % until we run out of preferred markers. Then it will use the next
        % line style with the first preferred marker. This continues until
        % all combinations of markers and line styles are used. The pattern
        % is then repeated if necessary
        count = count + 1;
        if count > length(prefMarkers)
            count = 1;
            lineStyleCount = lineStyleCount + 1;
            if lineStyleCount > length(prefLineStyles)
                lineStyleCount = 1;
            end
        end
    end
    
    if ~isempty(legendH)
        set(legendH,'location','eastoutside',...
            'orientation','vertical');  
    end
    
    set(xH, 'fontsize', axisLabelFontSize);
    set(yH, 'fontsize', axisLabelFontSize);
    set(axisH, 'fontsize', axesFontSize);
    if ~isempty(titleH)
        set(titleH,'fontsize',titleFontSize);
    end
    
    if ~isempty(xLims)
        set(axisH, 'xlim',xLims);
    end
    if ~isempty(yLims)
        set(axisH, 'ylim', yLims);
    end
end

