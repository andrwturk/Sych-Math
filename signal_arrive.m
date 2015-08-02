function y = signal_arrive(x, tau, sigma)
    % Calculates signal measured by sensors y from the original
    % signal x, taking into account channel delays in samples tau and channel noise sigma.
    y = signal_shift(repmat(x, length(tau), 1), tau, 'circular');
    y = y + normrnd(0, sigma, size(y));
end

