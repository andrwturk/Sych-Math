classdef UnitTest < matlab.unittest.TestCase
    % Unit tests.
    
    methods (Test)
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
        end
    end
    
end

