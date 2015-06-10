function [v, N] = signal_interchannel_variance(y)
% Interchannel variance of signal y for each time step.
    N = sum(~isnan(y));
    y(isnan(y)) = 0;
    v = sum(y.^2) ./ N - (sum(y) ./ N).^2;
end

