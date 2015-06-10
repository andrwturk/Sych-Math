function [data, fs] = read_data( filename )
% Read data file and return audio samples array.
    n_chan = 3;
    fs = 51000;
    n_bits = 12;
    
	f = fopen(filename, 'r');
    cu = onCleanup(@() fclose(f));
    
    data = fread(f, [n_chan, Inf], 'int16', 0, 'l');
    data = data / 2^(n_bits - 1) - 1;
end

