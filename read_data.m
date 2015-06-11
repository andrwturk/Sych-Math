function [data, fs] = read_data( filename )
    % Read data file and return audio samples array.
    % 1st dimension of data is a channes, 2ns is time.
    
    n_chan = 3;
    fs = 51000;
    n_bits = 12;
    
	f = fopen(filename, 'r');
    cu = onCleanup(@() fclose(f));
    
    data = fread(f, [n_chan, Inf], 'int16', 0, 'l');
    data = data / 2^(n_bits - 1) - 1;
end

