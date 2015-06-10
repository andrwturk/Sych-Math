function logL = log_lik(y, tau, sigma_n)
% log_lik_mex(y, tau, sigma_n)
    y_align = signal_align(y, tau);
    [v, N] = signal_interchannel_variance(y_align);
    j = N > 0;

    logL = sum(-(1/2) * log(N(j)) - (N(j) ./ (2 * sigma_n^2)) .* v(j));
end

