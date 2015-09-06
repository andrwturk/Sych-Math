function f = fft_freq_vector(N)
% Returns normalized frequency vector for FFT of length N with negative
% frequencies of the right.

    k = 0 : N - 1;
    k(k > N / 2) = k(k > N / 2) - N;
    
    % Normalized frequency vector
    f = k / N;
end

