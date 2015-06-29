function p = beamforming(y, tau)
% Frequency domain beamforming.
    [K, N] = size(y);
%     assert(mod(N, 2) == 1);
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

