%% Init sensor array.
v = sound_speed_air(293);
r = sensor_position() / v;

%% Load signal - claps new base.
[y, fs] = read_data('data/raw/Claps-NewBase/001_00h_0m_29s');
signal_plot(y, fs);

%% Load signal - claps new base, microphone up.
[y, fs] = read_data('data/raw/Claps-NewBaseMicsUp/003_00h_0m_26s');
signal_plot(y, fs);

%% Load signal - claps new base, microphone up -- clap from the direction of 2nd mic.
[y, fs] = read_data('data/raw/Claps-NewBaseMicsUp/from2ndmic');
signal_plot(y, fs);

%% Load signal - claps new base, microphone up -- 440Hz.
[y, fs] = read_data('data/raw/Claps-NewBaseMicsUp/005_00h_0m_24s');
signal_plot(y, fs);

%% Load signal - ak-47-left-100m, 1st single shot.
[y, fs] = read_data('data/wav/ak-47-right-100m-burst-1.wav');
signal_plot(y, fs);

%% Load signal - 0m_47s (first clap)
[y, fs] = read_data('data/raw/002_00h_0m_47s');
y = y(:, 75000 : 85000);
signal_plot(y, fs);

%% Load new recordings (13.07) file 1, clap 1.
[y, fs] = read_data('data/raw/001_00h_0m_07s');
y = y(:, 20000 : 40000);
clf; signal_plot(y, fs);

%% Load new recordings (13.07) file 1, clap 2.
[y, fs] = read_data('data/raw/001_00h_0m_07s');
y = y(:, 200000 : 210000);
clf; signal_plot(y, fs);

%% Load new recordings (13.07) file 2, clap 1.
[y, fs] = read_data('data/raw/003_00h_0m_03s');
y = y(:, 90000 : 120000);
clf; signal_plot(y, fs);

%% Load new recordings from the field
[y, fs] = read_data('data/wav/066_08h_8m_04s-1.wav');
clf; signal_plot(y, fs);

%% Load one channel of a clap signal.
[x, fs] = read_data('data/raw/002_00h_0m_47s');
x = x(1, 75000 : 85000);
% Make a delayed signal and add noise.
phi0 = deg2rad(70.5);
theta0 = deg2rad(20);
sigma = 0.0;
y = signal_arrive(x, -r.' * direction(phi0, theta0) * fs, sigma);

%% Init angles and lags.
phi = linspace(0, 2 * pi, 361);
% theta = zeros(size(phi));
% theta = deg2rad(linspace(0, 90, 91));
theta = 0;
[Phi, Theta] = meshgrid(phi, theta);
tau = -r.' * direction(Phi(:).', Theta(:).') * fs;

%% Beamforming
tic;
p = beamforming(y, -tau);
toc;
% polar(theta.', (p_sum - min(p_sum)) / (max(p_sum) - min(p_sum)));
% polar(phi.', p);
p = reshape(p, size(Phi));
imagesc(rad2deg(phi), rad2deg(theta), p);
axis xy;
% polar(phi, p);