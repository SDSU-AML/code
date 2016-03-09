function [ meg ] = calcMEG( XPD, thetaMesh, gTheta, gPhi, thetaDelta, phiDelta )
%CALCMEG Calculates Mean Effective Gain given gains and the points to use
%for the XPD values
    % Assume uniform distribution - P = 1/4/pi
    meg = [];
    for j = 1:length(XPD) % MEG_dB = 10*log10(MEG_lin) 
        xpd = 10^(XPD(j)/10); % convert to linear
        m = xpd/(1+xpd)*gTheta + 1/(1+xpd)*gPhi;
        m = 1/4/pi*m; % Uniform distribution
        m = m.*sin(abs(thetaMesh)); % sin(theta)
        m = m*phiDelta*pi/180*thetaDelta*pi/180; % dTheta * dPhi (rad)
        m = sum(sum(m)); % Double sum over all 3d space
        meg(end+1) = 10*log10(m);
    end

end

