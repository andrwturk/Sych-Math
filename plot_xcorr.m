function l = plot_xcorr(data, fs)
% Plot cross correlation between channels
    L = 1;
    v = 330;
    max_lag = ceil(2 * L / v * fs);
    [r12, lags] = xcorr(data(:, 1), data(:, 2), max_lag, 'unbiased');
    [r23, ~] = xcorr(data(:, 2), data(:, 3), max_lag, 'unbiased');
    [r31, ~] = xcorr(data(:, 3), data(:, 1), max_lag, 'unbiased');

    subplot(3, 1, 1); plot(lags / fs, r12); grid; title('r12');
    subplot(3, 1, 2); plot(lags / fs, r23); grid; title('r23');
    subplot(3, 1, 3); plot(lags / fs, r31); grid; title('r31');
    
    [~, I] = max([r12, r23, r31]);
    l = lags(I);
end

