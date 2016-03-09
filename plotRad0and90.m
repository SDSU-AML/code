function [ outArgs ] = plotRad0and90( theta,plotTraces,name0,name90,antName )
%PLOTRAD0AND90 Used to make the radiation pattern plots
%   Makes use of polar_dB, a helpful MATLAB function that is used to plot
%   polar graphs in dB units. This function was downloaded from the web
%   Credits for polar_dB include
%		S. Bellofiore
%		S. Georgakopoulos
%		A. C. Polycarpou
%		C. Wangsvick
%		C. Bishop
    fig = figure;
    ax = axes;
    rmin = -40;
    rmax = 10;
    rticks = 5;
    
    % Set figure info
    set(fig,'paperposition',[0.25 0.25 8 8]);
    set(fig,'position',[-1500,0,900,800])
    
    % Name information
    % Gets info.
        %   type = 'meas' or 'sim'
        %   freq as double
        %   phi as double
        %   gain = 'phi' or 'theta'
    nameInfo0 = getNameInfo(name0);
    nameInfo90 = getNameInfo(name90);
    
    % Marker skip
    mkSkip = 5; % Ever N points make a marker
    for i = 1:length(plotTraces)
        % PT order: gP_m, gT_m, gP_s, gT_s
        trace{i} = polar_dB(theta, plotTraces{i}, rmin, rmax, rticks);
        hold on;
        % Now plot the marker skipped version
        trace_mkSkip{i} = polar_dB(theta(1:mkSkip:end),...
            plotTraces{i}(1:mkSkip:end), rmin, rmax, rticks);
        % Now plot first point for legend
        trace_legend{i} = polar_dB(theta(1),...
            plotTraces{i}(1),rmin,rmax,rticks);
    end   
    
    markerTypes = {'o','none','o','none'};
    markerSizes = {9,9,9,9};
    lineWidths = {3,3,3,3};
    lineStyles = {'-',':',':','-'};
    colors = {[0 0 0], [0 0 0] ,[0 0 0] ,[0 0 0]};
    for i = 1:length(trace)
        % Set all trace characteristics here
        set(trace{i},'linewidth',lineWidths{i});
        set(trace{i},'color',colors{i});
        set(trace{i},'linestyle',lineStyles{i});
        
        set(trace_mkSkip{i},'linestyle','none');
        set(trace_mkSkip{i},'markeredgecolor',colors{i});
        set(trace_mkSkip{i},'markerfacecolor',colors{i});
        set(trace_mkSkip{i},'marker',markerTypes{i});
        set(trace_mkSkip{i},'markersize',markerSizes{i});
        
        % FOR LEGEND
        set(trace_legend{i},'linewidth',lineWidths{i});
        set(trace_legend{i},'color',colors{i});
        set(trace_legend{i},'linestyle',lineStyles{i});
        set(trace_legend{i},'markeredgecolor',colors{i});
        set(trace_legend{i},'markerfacecolor',colors{i});
        set(trace_legend{i},'marker',markerTypes{i});
        set(trace_legend{i},'markersize',markerSizes{i});
    end
    
    % Need to parse this to get more details (i.e. freq, phi cut, etc)
    h_leg = legend([trace_legend{1} trace_legend{2} trace_legend{3} trace_legend{4}],...
        'G\phi_{\phi=0}','G\theta_{\phi=0}','G\phi_{\phi=90}','G\theta_{\phi=90}');
    set(h_leg,'fontsize',18);
    set(h_leg,'location','southoutside')
    set(h_leg,'orientation','horizontal')
    
    set(fig, 'color', [1 1 1])
        
    outArgs.fig = fig;
    outArgs.axis = ax;
    outArgs.trace = trace;
    outArgs.trace_mkSkip = trace_mkSkip;
    outArgs.legend = h_leg;
    outArgs.fileName = sprintf('%s_%.2fGHz_%s.png',antName,nameInfo0.freq,nameInfo0.type);
end

