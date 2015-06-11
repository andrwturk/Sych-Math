function l = estimate_crosschannel_lag(data, max_lag)
    % Returns an n by n matrix of estimated lags between all channels. The
    % estibated lags are computed from maximum of cross-correlation.
    % l(i, j) is how much channel i is shifted forward in time relative to
    % channel j (positive lag means that the signal arrives at i later than
    % at j).
    n = size(data, 1);
    l = zeros(n);
    
    for i = 1 : n
        for j = i + 1 : n
            [r, lags] = xcorr(data(i, :), data(j, :), max_lag);
            [~, k] = max(r);
            l(i, j) = lags(k);
            l(j, i) = -lags(k);
        end
    end
end

