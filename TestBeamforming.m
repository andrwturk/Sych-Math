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
            
            testCase.verifyEqual(y, x, 'AbsTol', 1e-15);
        end
        
        function test_4(testCase)
            tau = 0.5;
            
            x1 = [0, 1, 0];
            X1 = fft(x1);
            Y1 = beamforming(X1, fft_freq_vector(length(X1)), tau);
            y1 = ifft(Y1);
            
            x2 = [0, 1, 0, 0, 0];
            X2 = fft(x2);
            Y2 = beamforming(X2, fft_freq_vector(length(X2)), tau);
            y2 = ifft(Y2);
            
%             testCase.verifyEqual(y2(1 : length(y1)), y1, 'AbsTol', 1e-15);
        end
    end
end

