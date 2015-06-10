% function take2()
clc
% close all
% clear all

% parameters
v = 340;      % speed of sound, m/s
L = 1;        % spread of microphones, m
f = 51000;    % frequency, Hz
dt = 1/f;     % time step, s
dl = dt * v;  % space resolution, m

%% calculate delays
% oClock = 1:1:12;
% angles = (12-oClock) * (2 * pi) / 12;

angleSamples = 48;

angles = 0:(2*pi/angleSamples):(2*pi);

dirVec = [cos(angles); sin(angles)]

micAng = [0 -2*pi/3 -4*pi/3]
micVec = 1/sqrt(3) * [cos(micAng); sin(micAng)]

charMat = -round((dirVec' * micVec)' ./ dl)


proj12 = L * cos(angles - pi/6);
proj13 = L * cos(angles + pi/6);
proj32 = L * cos(angles - pi/2);

delays12 = round(proj12 / dl);
delays13 = round(proj13 / dl);
delays32 = round(proj32 / dl);

shifts = [delays12; delays13; delays32]

%% open file
% % OPEN BINARY
%     fileName = 'dir3/002_00h_0m_47s';
%     file = fopen(fileName);
% %     FileInfo = dir([pwd,'\',fileName]);
% %     f = fread(file,[1 FileInfo.bytes/2], 'int16');
%     
%     n_chan = 3;
%     fs = 51000;
%     n_bits = 12;
% 
%     data = fread(file, [n_chan, Inf], 'int16', 0, 'l');
%     data = data / 2^(n_bits - 1) - 1;
%     fclose(file)
%     
% % Read signals
%     sound1 = data(1,:);
%     sound2 = data(2,:);
%     sound3 = data(3,:);

% % OPEN CSV
%     fileName = 'directions2/shootSound_1Hour_02-04-15';
%     sound = csvread(fileName);
%     sound_length = numel(sound)/3;
% % Read signals
%     sound1 = sound(1:sound_length);
%     sound2 = sound((sound_length+1):(2*sound_length));
%     sound3 = sound((2*sound_length+1):(3*sound_length));

sound = zeros(1,1001);
sound(500) = 1;
trueAngleInd = 4;
sound1 = circshift(sound, [0, charMat(1, trueAngleInd)]);
sound2 = circshift(sound, [0, charMat(2, trueAngleInd)]);
sound3 = circshift(sound, [0, charMat(3, trueAngleInd)]);

sounds = [sound1; sound2; sound3];
sigma = 0.1;
sounds = sounds + normrnd(0,sigma, size(sounds))

% Make same size
minsize = min([numel(sound1),numel(sound2),numel(sound3)])
sound1 = sounds(1, 1:minsize);
sound2 = sound2(1:minsize);
sound3 = sound3(1:minsize);

% % sound2 = circshift(sound1(1:minsize), 130);
% % sound3 = circshift(sound1(1:minsize), 130);

% % Normalize
% sound1 = sound1 - mean(sound1);
% sound2 = sound2 - mean(sound2);
% sound3 = sound3 - mean(sound3);

plot(sounds')

%% Analyze blocks
blockSize = 1000;
blockShift = 50;

V = zeros(1,round(numel(sound1)/blockShift));
A = zeros(1,round(numel(sound1)/blockShift));
index = 1;

% For each block
for blockBegin = 1%%:blockShift:(numel(sound1)-blockSize)
    % Take blocks 
    block = sounds(:, blockBegin:(blockBegin+blockSize-1));
%     block1 = sound1(blockBegin:(blockBegin+blockSize-1));
%     block2 = sound2(blockBegin:(blockBegin+blockSize-1));
%     block3 = sound3(blockBegin:(blockBegin+blockSize-1));

    block1 = block(1, :);
    block2 = block(2, :);
    block3 = block(3, :);


    rSum = zeros(1,numel(angles));
    for i=1:numel(angles)
        r1 = shiftDotProd(block1, block2, charMat(2,i) - charMat(1,i));
        r2 = shiftDotProd(block2, block3, charMat(3,i) - charMat(2,i));
        r3 = shiftDotProd(block3, block1, charMat(1,i) - charMat(3,i));
        rSum(i) = r1 + r2 + r3;
    end
    
    % progressbar
    blockBegin/numel(sound1)*100
    
    % find max
    [maxVal maxInd] = max(rSum);
    angle = 0 + 2*pi/angleSamples * maxInd;
    
    % fill array
    V(index) = maxVal / 1000000;
    A(index) = angle;
    index = index + 1;
end

%%
% figure, polar(A,V,'ro');
polar(angles,rSum,'bo');






