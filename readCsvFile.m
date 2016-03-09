function [ names, data ] = readCsvFile( filePath )
%READEXPORTEDRADPATTERNS Simple csv file reader.
%   Returns headers in names and entries in data
    firstLine = true;
    numRows = 0;
    f = fopen(filePath,'r');
    if f == -1
        error(sprintf('could not open filePath %s',filePath));
    end
    line = fgetl(f);
    while ischar(line)
        if firstLine
            firstLine = false;
            % Get names from first line
            names = strsplit(line,',');
            numColumns = length(names);
            data = zeros(0,numColumns);
            line = fgetl(f);
            continue
        end       
        % If it isn't the first line, save the data
        numRows = numRows + 1;
        values = strsplit(line,',');
        if length(values) ~= numColumns
            % ERROR
            error('SOMETHING WRONG - number of values is not the same as number of column names\n');
        end
        
        for i = 1:length(values)
            data(numRows,i) = str2double(values{i});
        end
        
        line = fgetl(f);
    end
    if fclose(f) == -1
        error('error closing file\n');
    end
end

