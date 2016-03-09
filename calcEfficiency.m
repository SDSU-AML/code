function [ eff ] = calcEfficiency( gain, thetaMesh, phiDelta, thetaDelta )
%CALCEFFICIENCY Calculates total efficiency given the 3D gain.
    eff = gain/4/pi;
    eff = eff.*sin(abs(thetaMesh)); % theta is always positive
    eff = eff*phiDelta*pi/180*thetaDelta*pi/180; % convert to rad
    eff = sum(sum(eff));
end

