function y = signal_corrfilter(x, k)
% Correlation filtering of signal x with kernel k.
    for i = size(x, 1) : -1 : 1
        y(i, :) = xcorr(x(i, :), k);
    end
end

