function y = signal_corrfilter(x, k)
% Correlation filtering of signal x with kernel k in time-domain.
    
    % Pad x and sig with zeros.
    N = size(x, 2) + size(k, 2) - 1;
    x(:, end + 1 : N) = 0;
    k(:, end + 1 : N) = 0;
    
    % ** Convert to frequency domain **
    X = fft(x, [], 2);
    S = fft(k, [], 2);
    
    % ** Compute correlation **
    X = X .* repmat(conj(S), size(X, 1), 1);

    % ** Convert to time domain **
    y = ifft(X, [], 2);
end

