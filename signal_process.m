function y = signal_process(x, tau, passband, sig)
% Performs correlation filtering and beamforming on an input signal.
% x [Nc x Nt] -- input signal in time-domain.
% tau [Nc x Nk] -- matrix of channel delays (in samples).
% passband [1 x 2] -- frequency passband (in normalized frequency units).
%   Only the frequencies within the passband are processed.
% sig [1 x Ns] -- time-domain signature signal used for correlation filtering.

    % ** Get sizes **
    [Nc, Nt] = size(x);
    assert(size(tau, 1) == Nc);
    Nk = size(tau, 2);
    assert(isvector(passband) && length(passband) == 2);
    assert(isrow(sig));
    Ns = length(sig);

    % Length of fft buffer.
    N = Nt + Ns - 1;
    
    % Make N odd, for correct frequency-domain shift.
    if mod(N, 2) == 0
        N = N + 1;
    end

    % Pad x and sig with zeros.
    x(:, end + 1 : N) = 0;
    sig(:, end + 1 : N) = 0;
    
    % ** Convert to frequency domain **
    X = fft(x, [], 2);
    S = fft(sig, [], 2);
    
    % ** Compute correlation **
    X = X .* repmat(conj(S), Nc, 1);
    
    % ** Beamforming **
    
    % Normalized frequency vector
    f = fft_freq_vector(N);
    
    % Indices corresponding to the frequency band.
    ind = passband(1) <= abs(f) & abs(f) <= passband(2);
    
    Y = zeros(Nk, N);
    Y(:, ind) = beamforming(X(:, ind), f(ind), -tau);

    % ** Convert to time domain **
    y = ifft(Y, [], 2);
end

