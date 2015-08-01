function [data, fs] = read_data( filename, samples )
    % Read data file and return audio samples array.
    % 1st dimension of data is a channes, 2ns is time.
    
    [~, ~, ext] = fileparts(filename);
    
    if nargin < 2
        samples = [1, Inf];
    end
    
    if strcmp(ext, '.wav')
        [data, fs] = audioread(filename, samples);
        data = data.';
    else
        n_chan = 3;
        fs = 51000;
        n_bits = 12;
        bytes_per_sample = n_chan * 2;

        f = fopen(filename, 'r');
        cu = onCleanup(@() fclose(f));
        
        % Determine how many samples to read and seek to the starting
        % position depending of the start and end sample.
        if nargin > 1
            fseek(f, (samples(1) - 1) * bytes_per_sample, 'bof');
            samples_to_read = samples(2) - samples(1) + 1;
        else
            samples_to_read = Inf;
        end

        data = fread(f, [n_chan, samples_to_read], 'int16', 0, 'l');
        data = data / 2^(n_bits - 1) - 1;
    end
end

