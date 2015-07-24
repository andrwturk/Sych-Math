function r = sensor_position(L)
    % Returns array of sensor coordinates in 2D.
    % Number of rows in r is equal to number of sensors.
    % The two columns are x and y coordinates.
    
    % L -- distance between microphones.
    
    if nargin < 1
        L = 0.335;
    end
    
    n_rec = 3;
    
    % Radius of microphone circle.
    R = L / (2 * sin(pi / n_rec));

    % The channels are places clockwise in the hardware, but the angle
    % is counted counterclockwise. Therefore, channel 1 mic is placed at
    % angle -2*pi/3 and channel 2 mic is at 2*pi/3.
    phi = [0, -2 * pi / 3, 2 * pi / 3];
    
    % Elevation of microphones.
    theta = [0, 0, 0];
    
    r = R * direction(phi, theta);
end


