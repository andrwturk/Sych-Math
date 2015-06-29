%% Init sensor array.
v = sound_speed_air(293);
r = sensor_position() / v;

%% Load signal - claps new base.
[y, fs] = read_data('data/raw/Claps-NewBase/001_00h_0m_29s');
signal_plot(y, fs);

%% Load signal - ak-47-left-100m, 1st single shot.
[y, fs] = read_data('data/wav/ak-47-right-100m-burst-1.wav');
signal_plot(y, fs);

%% Load signal - 0m_47s (first clap)
[y, fs] = read_data('data/raw/002_00h_0m_47s');
y = y(:, 75000 : 85000);
signal_plot(y, fs);

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
p = beamforming(y1, -tau);
toc;
% polar(theta.', (p_sum - min(p_sum)) / (max(p_sum) - min(p_sum)));
% polar(phi.', p);
p = reshape(p, size(Phi));
imagesc(rad2deg(phi), rad2deg(theta), p);
axis xy;
% polar(phi, p);