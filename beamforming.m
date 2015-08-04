function p = beamforming(y, tau, freq_band)
% Frequency domain beamforming.
% tau -- array of channel delays (in samples). Rows of tau correspond to channels,
% columns correspond to different directions of arrival.
% freq_band = [f_min, f_max] -- NORMALIZED frequency-of-interest range. Only the
% frequencies within the [f_min, f_max] range are taken into account. If
% not specified, the [0, Inf] range is assumed.

    if nargin < 3
        freq_band = [0, Inf];
    end
    
    % Append zeros to make the number of time samples odd, for correct
    % frequency-domain shift.
    if mod(size(y, 2), 2) == 0
        y(:, end + 1) = 0;
    end
    
    [K, N] = size(y);
    assert(mod(N, 2) == 1);
    M = size(tau, 2);
    assert(size(tau, 1) == K);
    
    Y = fft(y, [], 2) / N;
    k = 0 : N - 1;
    k(k > N / 2) = k(k > N / 2) - N;
    
    % Frequency vector
    f = k / N;
    
    % Indices corresponding to the frequency band.
    ind = freq_band(1) <= abs(f) & abs(f) <= freq_band(2);

    p = zeros(M, 1);
    parfor i = 1 : M
        y1 = sum(Y(:, ind) .* exp(-2i * pi * tau(:, i) * f(ind)));
        p(i) = y1 * y1';
    end
end

