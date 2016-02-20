function Y1 = beamforming(Y, f, tau)
% Frequency domain beamforming.
% Y [K x N] -- input signal in frequency domain
% f [1 x N] -- frequency vector
% tau [K x M] -- array of channel delays. Rows of tau correspond to channels,
% columns correspond to different directions of arrival.
% freq_band = [f_min, f_max] -- NORMALIZED frequency-of-interest range. Only the
% frequencies within the [f_min, f_max] range are taken into account. If
% not specified, the [0, Inf] range is assumed.
% Output:
% Y1 [M x N] -- beamformed signals corresponding to M different delay vectors.

    [K, N] = size(Y);
%     assert(mod(N, 2) == 1);
    assert(isrow(f) && length(f) == N);
    M = size(tau, 2);
    assert(size(tau, 1) == K);
    
    Y1 = zeros(M, N);
    parfor i = 1 : M
        Y1(i, :) = sum(Y .* exp(-2i * pi * tau(:, i) * f));
    end
end

