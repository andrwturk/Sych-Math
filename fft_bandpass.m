function y = fft_bandpass(x, fs, pb)
% Banpass filtering based on FFT
    assert(isvector(pb) && length(pb) == 2);
    N = size(x, 2);
    f = [0 : floor(N/2), (floor(N/2) + 1 : N-1) - N] * fs / N;
    X = fft(x, [], 2);
    X(:, ~(abs(f) >= pb(1) & abs(f) <= pb(2))) = 0;
    y = ifft(X, [], 2);
end

