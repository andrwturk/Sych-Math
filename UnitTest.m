classdef UnitTest < matlab.unittest.TestCase
    % Unit tests.
    
    methods (Test)
        function testSensorPosition(testCase)
            r = sensor_position();
            testCase.verifyEqual(pairwise_distance(r.', r.'), [...
                0, 1, 1;
                1, 0, 1;
                1, 1, 0], 'AbsTol', 1e-15);
            testCase.verifyEqual(r(3, :), [0, 0, 0]);
        end
        
        function testSignalShift(testCase)
            y = [...
                1, 2, 3; 
                4, 5, 6; 
                7, 8, 9];
            testCase.verifyEqual(signal_shift(y, [0; -2; 1], 'circular'), [...
                1, 2, 3;
                6, 4, 5;
                9, 7, 8]);
            testCase.verifyEqual(signal_shift(y, [0; -2; 1], 'linear'), [...
                NaN, NaN,   1,   2,   3  NaN;
                4,     5,   6, NaN, NaN, NaN;
                NaN, NaN, NaN,   7,   8, 9  ]);
            
            y = [1, 0, 0; 1, 0, 0; 1, 0, 0];
            testCase.verifyEqual(signal_shift(y, [1; 2; 3], 'linear', 'full'), [...
                1     0     0   NaN   NaN
              NaN     1     0     0   NaN
              NaN   NaN     1     0     0]);
          
            testCase.verifyEqual(signal_shift(y, [1; 2; 3], 'linear', 'valid'), [...
                0
                0
                1]);
        end
        
        function testTimeDomainBeamforming(testCase)
            % Load one channel of a clap signal.
            [data, fs] = read_data('data/raw/002_00h_0m_47s');
            data = data(1, 75000 : 85000);
            
            % Init angles and lags.
            r = sensor_position();
            phi = linspace(0, 2 * pi, 100);
            theta = zeros(size(phi));
            v = 340;
            tau = -r.' / v * direction(phi, theta) * fs;
            
            % Make a delayed signal and add noise.
            phi0 = deg2rad(70);
            theta0 = 0;
            sigma = 0.03;
            data_noisy = signal_arrive(data, -r.' / v * direction(phi0, theta0) * fs, sigma);

            % Delay-and-sum
            y = delay_and_sum(data_noisy, -round(tau));
            p = y.^2;
            p_sum = mean(p, 2);
            % polar(phi.', (p_sum - min(p_sum)) / (max(p_sum) - min(p_sum)));
            polar(phi.', p_sum);
        end
    end
    
end

