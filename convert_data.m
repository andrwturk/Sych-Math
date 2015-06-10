in_dir = 'data/raw';
out_dir = 'data/wav';
files = dir(in_dir);

for i = 1 : length(files)
    if ~files(i).isdir
        [data, fs] = read_data(fullfile(in_dir, files(i).name));
        audiowrite(fullfile(out_dir, [files(i).name, '.wav']), data, fs, 'BitsPerSample', 32);
    end
end