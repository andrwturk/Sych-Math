function y_align = signal_align(y, tau)
% Align signal y using integer delay values tau.
    [K, N] = size(y);
    assert(isequal(size(tau), [K, 1]));
   
    tau_max = max(tau);
    tau_min = min(tau);
    y_align = NaN(K, N + tau_max - tau_min);

    for k = 1 : K
        y_align(k, tau_max - tau(k) + (1 : N)) = y(k, :);
    end
end

