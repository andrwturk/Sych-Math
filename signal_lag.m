function tau = signal_lag(r_rec, theta)
    % Calculate channel delays tau for angle theta(i).
    % r_rec(i, :) is a 2-d position vector of i-th receiver.
    % theta is a row-vector of angles of signal ARRIVAL (OPPTOSITE TO angle of PROPAGATION).
    % Output units are the same as in r_rec.
    assert(isrow(theta));
    tau = -r_rec * [cos(theta); sin(theta)];
end

