function y1 = delay_and_sum(y, tau)
% Delay-and-sum beamformer.
    [K, N] = size(y);
    M = size(tau, 2);
    assert(size(tau, 1) == K);
    
    y1 = zeros(M, N);
    for i = 1 : M
        y1(i, :) = sum(signal_shift(y, tau(:, i)));
    end
end

