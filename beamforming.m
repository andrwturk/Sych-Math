function p = beamforming(y, tau)
% Frequency domain beamforming.
% tau -- array of channel delays (in samples). Rows of tau correspond to channels,
% columns correspond to different directions of arrival.
    
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

    p = zeros(M, 1);
    parfor i = 1 : M
        y1 = sum(Y .* exp(-2i * pi * tau(:, i) * k / N));
        p(i) = y1 * y1';
    end
end

