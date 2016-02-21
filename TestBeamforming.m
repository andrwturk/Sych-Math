classdef TestBeamforming < matlab.unittest.TestCase
    % Unit tests.
    
    methods (Test)
        function test_1(testCase)
            x = 1 : 5;
            X = fft(x);
            tau = 1;
            Y = beamforming(X, fft_freq_vector(length(X)), tau);
            y = ifft(Y);
            
            testCase.verifyEqual(y, circshift(x, tau, 2), 'AbsTol', 1e-15);
        end
        
        function test_2(testCase)
            x = 1 : 5;
            X = fft(x);
            tau = -1;
            Y = beamforming(X, fft_freq_vector(length(X)), tau);
            y = ifft(Y);
            
            testCase.verifyEqual(y, circshift(x, tau, 2), 'AbsTol', 1e-15);
        end
        
        function test_3(testCase)
            x = 1 : 5;
            X = fft(x);
            tau = 0;
            Y = beamforming(X, fft_freq_vector(length(X)), tau);
            y = ifft(Y);
            
            testCase.verifyEqual(y, y, 'AbsTol', 1e-15);
        end
    end
end

