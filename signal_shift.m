function y_align = signal_shift(y, tau, shifttype, shape)
    % Shift channels of signal y by corresponding delay tau.
    % tau must be a column vector
    % with the same number of rows as y, equal to number of channels.
    % Positive delays mean shift to the right (lag), negative to the left
    % (lead).
    % shifttype specifies a type of shift to be performed -- 'linear' or
    % 'circular'. The default is 'circular'.
    % In case of linear shift, the unmatched samples are set to NaN.
    %
    % Circular shift is performed in frequency domain and supports
    % fractional shift values. Note that for signals of even size the
    % result of the shift will be, in general, complex.
    [K, N] = size(y);
    assert(isequal(size(tau), [K, 1]));
    
    if nargin < 3
        shifttype = 'circular';
    end
    
    if nargin < 4
        shape = 'full';
    end
    
    tau_max = max(tau);
    tau_min = min(tau);            
   
    switch shifttype
        case 'linear'
            y_align = NaN(K, N + tau_max - tau_min);

            for k = 1 : K
                y_align(k, tau(k) - tau_min + (1 : N)) = y(k, :);
            end
        case 'circular'
            % Row-wise FFT
            Y = fft(y, [], 2);
            N = size(Y, 2);
            k = 0 : N - 1;
            k(k > N / 2) = k(k > N / 2) - N;
            
            for c = 1 : K
                Y(c, :) = Y(c, :) .* exp(-1i * 2 * pi * k * tau(c) / N);
            end
            
            % Inverse FFT
            y_align = ifft(Y, [], 2);

        otherwise
            error('Unknown shifttype %s', shifttype);
    end
    
    switch shape
        case 'full'
            % Do nothing.
        case 'valid'
            if strcmp(shifttype, 'circular')
                error('shape ''valid'' is not supported for ''circular'' shifts');
            end
            
            % Cut the parts with unmatched/wrapped samples.
            n_cut = floor(tau_max - tau_min);
            y_align(:, [1 : n_cut, end - n_cut + 1 : end]) = [];
%         case 'same'
        otherwise
            error('Unknown shape %s', shape);
    end
        
end

