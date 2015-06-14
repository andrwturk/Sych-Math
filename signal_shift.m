function y_align = signal_shift(y, tau, shifttype)
    % Shift channels of signal y by corresponding delay tau.
    % tau must be a column vector
    % with the same number of rows as y, equal to number of channels.
    % Positive delays mean shift to the right (lag), negative to the left
    % (lead).
    % shifttype specifies a type of shift to be performed -- 'linear' or
    % 'circular'. The default is 'circular'.
    % In case of linear shift, the unmatched samples are set to NaN.
    [K, N] = size(y);
    assert(isequal(size(tau), [K, 1]));
    
    if nargin < 3
        shifttype = 'circular';
    end
   
    switch shifttype
        case 'linear'
            tau_max = max(tau);
            tau_min = min(tau);
            y_align = NaN(K, N + tau_max - tau_min);

            for k = 1 : K
                y_align(k, tau(k) - tau_min + (1 : N)) = y(k, :);
            end
        case 'circular'
            y_align = zeros(size(y));
            
            for k = 1 : K
                y_align(k, :) = circshift(y(k, :), tau(k), 2);
            end
        otherwise
            error('Unknown shifttype %s', shifttype);
    end
end

