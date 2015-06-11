function tau = signal_lag(r, theta)
    % Calculate channel delays tau for angle of arrival theta.
    % Rows of r correspond to [x, y] sensor coordinates.
    % theta is a row-vector of angles of signal ARRIVAL (OPPTOSITE TO angle of PROPAGATION).
    % tau is size(r, 1) by length(theta) array of lags for all combinations
    % of sensor and angle of arrival.
    % All lags are relative to the origin [0, 0]. Lag at origin is 0. The
    % lags are not rounded.
    assert(isrow(theta));
    tau = -r * [cos(theta); sin(theta)];
end

