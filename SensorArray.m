classdef SensorArray
    % Array of sensors.
    % Sensors are located at different positions and measure a signal
    % arriving from a certain direction. The direction of arrival could be
    % estimated from the signal delays.
    
    properties
        % Sensor positions, one row per sensor.
        r;
    end
    
    methods
        function this = SensorArray(r_)
            % Constructor.
            this.r = r_;
        end
        
        function y = ArrivedSignal(this, x, v, fs, sigma)
            % Calculates signal measured by sensors y from the original
            % signal x, taking into account sensor positions r, wave
            % velocity v, sample rate fs and standard deviation of noise sigma.
            % Make a delayed signal and add noise.
            theta0 = deg2rad(70);
            tau0 = signal_lag(r / v * fs, theta0);
            sigma = 0.1;
            data = signal_shift(repmat(data, size(r, 1), 1), tau0);
            data_noisy = data + normrnd(0, sigma, size(data));
        end
    end
    
end

