function [ info ] = getNameInfo( name )
%GETNAMEINFO Used to parse the names in order to get simulated
%or measured, gain type, and phi cut.

    if ~isempty(strfind(name, '[deg]'))
        error('Trying to parse theta! Something wrong\n');
    end

    if name(1) == '"'
        name = name(2:end-1); % remove " "
    end
    
    if isempty(strfind(name,'_M'))
        info.type = 'Simulated';
    else
        info.type = 'Measured';
    end

    aps = strfind(name,'''');
    a = aps(1)+1;
    b = aps(2)-1-3;
    info.freq = str2num(name(a:b));
    a = aps(3)+1;
    b = aps(4)-1-3;
    info.phi = str2num(name(a:b));
    
    i = strfind(name,'Gain');
    if strcmpi(name(i+4),'P')
        info.gain = 'phi';
    elseif strcmpi(name(i+4),'T')
        info.gain = 'theta';
    end
end

