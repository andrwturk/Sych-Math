classdef TestFilterBeamformer < matlab.unittest.TestCase
    % Unit tests.
    
    methods (Test)
        function test_1(testCase)
            fb = FilterBeamformer(1, 0, 1);
            x = 1 : 5;
            y = zeros(size(x));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y, x);
        end
        
        function test_2(testCase)
            fb = FilterBeamformer(1, [0, 1], 1);
            testCase.assertEqual(fb.bufferLength, 3);
            testCase.assertEqual(size(fb.tail), [2, 2]);
            
            x = 1 : 5;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y(1, :), [0, x(1 : end - 1)], 'AbsTol', 1e-15);
            testCase.verifyEqual(y(2, :), x, 'AbsTol', 1e-15);
        end
        
        function test_3(testCase)
            fb = FilterBeamformer(1, [0, 1], 2);
            testCase.assertEqual(fb.bufferLength, 3);
            testCase.assertEqual(size(fb.tail), [2, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y(1, :), [0, x(1 : end - 1)], 'AbsTol', 1e-15);
            testCase.verifyEqual(y(2, :), x, 'AbsTol', 1e-15);
        end
        
        function test_4(testCase)
            fb = FilterBeamformer(7, [0, 1], 2);
            testCase.assertEqual(fb.bufferLength, 3);
            testCase.assertEqual(size(fb.tail), [2, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y(1, :), 7 * [0, x(1 : end - 1)], 'AbsTol', 1e-14);
            testCase.verifyEqual(y(2, :), 7 * x, 'AbsTol', 1e-14);
        end
        
        function test_5(testCase)
            fb = FilterBeamformer([1, -1], 0, 1);
%             testCase.assertEqual(fb.bufferLength, 3);
%             testCase.assertEqual(size(fb.tail), [1, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y, -diff([0, x], 1, 2), 'AbsTol', 1e-14);
        end
        
        function test_6(testCase)
            fb = FilterBeamformer([1, -1], 0, 2);
%             testCase.assertEqual(fb.bufferLength, 3);
%             testCase.assertEqual(size(fb.tail), [1, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y(:, 1 : end - 1), -diff(x, 1, 2), 'AbsTol', 1e-14);
        end
        
        function test_7(testCase)
            fb = FilterBeamformer([1, -1, 0, 0], 0, 3);
%             testCase.assertEqual(fb.bufferLength, 3);
%             testCase.assertEqual(size(fb.tail), [1, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y, -diff([0, 0, 0, x(1 : end - 2)], 1, 2), 'AbsTol', 1e-14);
        end
        
        function test_8(testCase)
            fb = FilterBeamformer([1, -1], [0, 1], 2);
%             testCase.assertEqual(fb.bufferLength, 3);
%             testCase.assertEqual(size(fb.tail), [1, 1]);
            
            x = 1 : 6;
            y = zeros(fb.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / fb.frameLength)
                ind = (1 : fb.frameLength) + (i - 1) * fb.frameLength;
                y(:, ind) = fb.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y(1, :), [0, -diff([0, x(1 : end - 1)])], 'AbsTol', 1e-14);
            testCase.verifyEqual(y(2, :), -diff([0, x]), 'AbsTol', 1e-14);
        end
        
        function test_FrameWise_1(testCase)
            % Init database
            db = Database();

            % Load signal
            [x, fs] = db.getAudioData(2);

            % Init sensor array.
            v = sound_speed_air(293);
            r = sensor_position() / v;
            phi = linspace(0, 2 * pi, 361);
            theta = 0;
            [Phi, Theta] = meshgrid(phi, theta);
            tau = -r.' * direction(Phi(:).', Theta(:).') * fs;
%             tau(:) = 0;

            % Beamformers
            S = load('data/sig.mat', 'sig');    % Load muzzleflash signature signal
            bf1 = FilterBeamformer(S.sig, tau, size(x, 2)); % Full-length
            
            frame_length = 513;
            bf2 = FilterBeamformer(S.sig, tau, frame_length); % Small frame

            y1 = bf1.ProcessFrame(x);
            y2 = zeros(bf2.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / frame_length)
                ind = (1 : frame_length) + (i - 1) * frame_length;
                y2(:, ind) = bf2.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y2(:, 1 : ind(end)), y1(:, 1 : ind(end)), 'AbsTol', 1e-2);
        end
        
        function test_FrameWise_2(testCase)
            % Init database
            db = Database();

            % Load signal
            [x, fs] = db.getAudioData(2);

            % Init sensor array.
            tau = [10; 0; -20];
%             tau = ...
%               [-28.7534;
%                14.3767;
%                14.3767] / 100;

            % Beamformers
            S = load('data/sig.mat', 'sig');    % Load muzzleflash signature signal
            sig = S.sig;
%             sig(:) = 0;
%             sig(1) = 1;
%             sig(2) = -1;
            bf1 = FilterBeamformer(sig, tau, size(x, 2)); % Full-length
            
            frame_length = 513;
            bf2 = FilterBeamformer(sig, tau, frame_length); % Small frame

            y1 = bf1.ProcessFrame(x);
%             testCase.assertEqual(y1, sum([[0; 0; 0], -diff(x, 1, 2)], 1), 'AbsTol', 1e-10);
            
            y2 = zeros(bf2.numDirections, size(x, 2));
            
            for i = 1 : floor(length(x) / frame_length)
                ind = (1 : frame_length) + (i - 1) * frame_length;
                y2(:, ind) = bf2.ProcessFrame(x(:, ind));
            end
            
            testCase.verifyEqual(y2(:, 1 : ind(end)), y1(:, 1 : ind(end)), 'AbsTol', 1e-10);
        end
    end
end

