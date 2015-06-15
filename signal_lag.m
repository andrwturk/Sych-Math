function tau = signal_lag(r, v)
    % Calculate channel delays tau for angle of arrival theta.
    % Columns of r correspond to sensor coordinates.
    % v is a column-vector of wave PROPAGATION speed.
    % tau is and array has of lags with size(r, 2) rows for all combinations
    % of sensor and angle of arrival.
    % All lags are relative to the origin [0, 0]. Lag at origin is 0. The
    % lags are not rounded.
    assert(isequal(size(v), [3, 1]));
    tau = (r.' * v) / (v.' * v);
end

