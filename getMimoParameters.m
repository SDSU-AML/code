function [ output ] = getMimoParameters( freq, S11, S12, S21, S22, gainFiles, gain )
%GETMIMOPARAMETERS This function is similar calculates and returns all
%necessary information to plot MIMO parameters.
%   output format includes:
%       output.freq
%       output.S11dB
%       output.S12dB
%       output.S21dB
%       output.S22dB
%       output.phi
%       output.gainPhiDb
%       output.gainThetaDb
%       output.cl (Capacity Loss)
%       output.tarc (Total Active Reflection Coefficient)
%       output.rho (Correlation factor)
%       output.meg (Mean Effective Gain)

    numGainFreqs = length(gain);
    for i = 1:numGainFreqs
        importedGain(i) = importdata(gainFilesCell{i});
    end

    if numGainFreqs > 0
        phi = gain{1}.phi; % Assumed the same in all for now
    else
        phi = [];
    end
    for i = 1:numGainFreqs
        gainPhi(i,:) = gain{i}.gainPhi;
        gainTheta(i,:) = gain{i}.gainTheta;
    end
    
    output.freq = freq;
    output.S11dB = 20*log10(abs(S11));
    output.S12dB = 20*log10(abs(S12));
    output.S21dB = 20*log10(abs(S21));
    output.S22dB = 20*log10(abs(S22));
    
    output.phi = phi;
    for i = 1:numGainFreqs
        output.gainPhiDb(i,:) = 20*log10(gainPhi(i,:));
        output.gainThetaDb(i,:) = 20*log10(gainTheta(i,:));
    end
    
    % Capacity loss
    psiR = zeros(2,2);
    output.cl = zeros(1,length(freq));
    for i = 1:length(freq)
        psiR(1,1) = 1-(abs(S11(i)).^2 + abs(S12(i)).^2);
        psiR(1,2) = -(conj(S11(i)).*S12(i) + conj(S21(i)).*S22(i));
        psiR(2,1) = -(conj(S22(i)).*S21(i) + conj(S12(i)).*S11(i));
        psiR(2,2) = 1-(abs(S22(i)).^2 + abs(S21(i)).^2);
        output.cl(i) = -log2(det(psiR));
    end
    
    % TARC
    output.tarcThetaVals = 0:30:180;
    output.tarc = zeros(length(output.tarcThetaVals),length(freq));
    for i = 1:length(output.tarcThetaVals)
        for j = 1:length(freq)
            theta = output.tarcThetaVals(i);
            output.tarc(i,j) = sqrt(abs(S11(j)+S12(j).*exp(complex(0,1)*theta))^2 +...
                abs(S21(j)+S22(j).*exp(complex(0,1)*theta))^2)/sqrt(2);
        end
    end
    
    % Correlation factor
    num =  abs(conj(S11).*S12+conj(S21).*S22).^2;
    den1 = (1-abs(S11).^2-abs(S21).^2);
    den2 = (1-abs(S22).^2-abs(S12).^2);
    output.rho = num./den1./den2;    
    
    % New Mean Effective Gain (MEG) calculations
    % 
    % Assumes uniform probability distribution for incident waves (i.e.
    % P(theta,phi)=1/(4pi) (1 over solid angle)
    output.xpdValsDb = -40:5:40;
    xpdVals = 10.^(output.xpdValsDb/20);
    deltaPhi = 2/180*pi; % radians -> 2 degrees is assumed for now
    output.meg = zeros(length(xpdVals),numGainFreqs);
    for i = 1:length(xpdVals)
        for j = 1:numGainFreqs
            xpd = xpdVals(i);
            gTheta = xpd/(1+xpd)*gainTheta(j,:);
            gPhi = 1/(1+xpd)*gainPhi(j,:);
            output.meg(i,j) = (1/2/pi)*sum(gTheta+gPhi)*deltaPhi;
        end
    end
end

