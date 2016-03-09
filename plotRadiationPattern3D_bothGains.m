function [ figs ] = plotRadiationPattern3D_bothGains( fileName, antennaName )
%PLOTRADIATIONPATTERN3D Summary of this function goes here
%   Detailed explanation goes here

    realColorLim = [-40 10]; % limits for color bar/range

    fillBool = true; % Duplicates the first cut to fill in gap if true
    twoColor = false; % Use two color sets or one for gainPhi and gainTheta
    titleFontSize = 20;
    numCuts = 9; % Number of Phi cuts
    phiDelta = 20; % Delta for phi
    thetaDelta = 2; % Delta for theta
    
    [names, data] = readCsvFile(fileName); % Load data
    
    if fillBool
        phi = 0:phiDelta:(numCuts)*phiDelta;
    else
        phi = 0:phiDelta:(numCuts-1)*phiDelta;
    end
    
    theta = -180:thetaDelta:180;
    phi = phi*pi/180;   % Angle from positive x axis in xy plane
    theta = theta*pi/180; % Angle from positive z axis in phi plane
    ele = pi/2-theta; % Elevation above xy plane - needed for sph2cart
    [phiMesh,eleMesh] = meshgrid(phi,ele);
    
    gainOffset = (size(data,2)-1)/2;
    figs = {};
    for i = 2:numCuts:gainOffset-1
        info = getNameInfo(names{i});
        % Info can tell us if we have theta or phi gains
        startPhi = i;
        endingPhi = i+numCuts-1;
        startTheta = startPhi+gainOffset;
        endingTheta = endingPhi+gainOffset;
        
        gainPhi = data(:,startPhi:endingPhi);
        gainTheta = data(:,startTheta:endingTheta);
                
        % Duplicate the first cut into the last cut (to fill in 3D mesh)
        if fillBool == true
            gainPhi(:,end+1) = flipud(gainPhi(:,1));
            gainTheta(:,end+1) = flipud(gainTheta(:,1));
        end
                
        minPhi = min(min(gainPhi));
        minTheta = min(min(gainTheta));
        minGain = min(minPhi,minTheta);
        gainPhiNorm = gainPhi - minGain; % Normalize
        gainThetaNorm = gainTheta - minGain; % Normalize
       
        [Xphi,Yphi,Zphi] = sph2cart(phiMesh,eleMesh,gainPhiNorm);
        [Xtheta,Ytheta,Ztheta] = sph2cart(phiMesh,eleMesh,gainThetaNorm);
        
        f.fig = figure;
        f.axes = axes;
        
        span = realColorLim(2)-realColorLim(1);
        if twoColor
            clims = realColorLim + [0 span];
            colormap([cool(64);flipud(autumn(64))]);
        else
            clims = realColorLim;
        end
            
        set(f.fig,'color',[1 1 1]);
        set(f.fig,'position',[100 100 750 800]);

        % Save the data too
        % Use this for calculating diff between sim and measured
        % Also save name info
        f.info = info;
        f.gainPhi = gainPhi;
        f.gainTheta = gainTheta;
        f.phiMesh = phiMesh;
        f.eleMesh = eleMesh;
        
        f.hPhi = surf(f.axes,Xphi,Yphi,Zphi,gainPhi); % use non-norm gain for color
        set(f.hPhi, 'edgecolor',[0 0 0]);
        
        hold(f.axes,'on');
        if twoColor
            f.hTheta = surf(f.axes,Xtheta,Ytheta,Ztheta,gainTheta+span);
        else
            f.hTheta = surf(f.axes,Xtheta,Ytheta,Ztheta,gainTheta);
        end
        
        xlabel('x','fontsize',24);
        ylabel('y','fontsize',24);
        zlabel('z','fontsize',24);
        
        % Need to set clims here
        set(f.axes,'clim',clims);
        set(f.hTheta,'edgecolor',[0 0 0]);
        
        if twoColor
            f.colorBarHtheta = colorbar('location','southoutside');
            curPos = get(f.colorBarHtheta,'position');
            f.colorBarHphi = colorbar('location','southoutside',...
                'position',curPos+[0 curPos(4)*1.5 0 0]);
            set(f.colorBarHphi,'xticklabel','') % removes labels
            set(f.colorBarHphi,'xlim',realColorLim);
            set(f.colorBarHtheta,'xlim',realColorLim+[span span]);
            % set tick labels for colorBarHtheta
            tickLabels = num2str([realColorLim(1):5:realColorLim(2)]');
            set(f.colorBarHtheta,'xticklabel',tickLabels); % for horizontal
            % Set labels for gain phi and gain theta
            labelPhi = ylabel(f.colorBarHphi,'Gain\phi');
            labelTheta = ylabel(f.colorBarHtheta,'Gain\theta');
        else
            f.colorBarHtheta = colorbar('location','northoutside');
        end
                
        f.saveAs = sprintf('%s_%.2fGHz_%s',...
            antennaName,...
            info.freq,...
            info.type);

        set(f.axes,'xticklabel',{});
        set(f.axes,'yticklabel',{});
        set(f.axes,'zticklabel',{});
        axis(f.axes,'square');
        
        figs{end+1} = f;
    end
end

