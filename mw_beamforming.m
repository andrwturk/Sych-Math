function [p, t] = mw_beamforming(y, tau, window_len, window_ofs)
% Moving window beamforming
    
    N = size(y, 2);    
    nW = floor((N - window_len) / window_ofs + 1);
    w_begin = (0 : nW - 1) * window_ofs + 1;

    p = zeros(size(tau, 2), nW);

    parfor iw = 1 : nW
        % Current window range.
        range = w_begin(iw) : w_begin(iw) + window_len - 1;

        % Calculate the power for current window.
        p(:, iw) = beamforming(y(:, range), tau);
    end
    
    t = w_begin - 1 + window_len / 2;
end

