function Y1 = beamforming(Y, f, tau)
% Frequency-domain beamforming.
%
% Y [K x N] -- input signal in frequency domain
% f [1 x N] -- frequency vector
% tau [K x M] -- array of channel delays in samples. Rows of tau correspond to channels,
% columns correspond to different directions of arrival. tau can have
% fractional values.
%
% Each channel k is shifted by tau(k) samples in time-dimain and then the
% channel are sumed up.
%
% Output:
% Y1 [M x N] -- beamformed signals corresponding to M different delay vectors.

    [K, N] = size(Y);
%     assert(mod(N, 2) == 1);
    assert(isrow(f) && length(f) == N);
    M = size(tau, 2);
    assert(size(tau, 1) == K);
    
    Y1 = zeros(M, N);
    for i = 1 : M
        Y1(i, :) = sum(Y .* exp(-2i * pi * tau(:, i) * f), 1);
    end
end

