function plot_xcorr(data, max_lag, corrtype, fs)
    % Plot cross-correlation between channels
    % max_lag -- maximum lag value to plot; set to [] to specify maximum
    % possible.
    % corrtype -- type of cross-correlation, can be 'biased' or 'unbiased'.
    % The default is 'unbiased'
    % fs -- sampling frequency (is specified, horizontal plot axis is in
    % time units, otherwise in integer lags). The default is 1.
    
    if nargin < 2
        max_lag = [];
    end
    
    if nargin < 3
        corrtype = 'unbiased';
    end
    
    if nargin < 4
        fs = 1;
    end

    n_chan = size(data, 1);
    for i = 1 : n_chan
        for j = 1 : n_chan
            [r, lags] = xcorr(data(i, :), data(j, :), max_lag, corrtype);
            subplot(n_chan, n_chan, (i - 1) * n_chan + j);
            plot(lags / fs, r); grid; title(sprintf('r_{%d,%d}', i, j));
        end
    end
end

