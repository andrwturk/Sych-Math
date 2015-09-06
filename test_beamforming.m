%% Init sensor array.
v = sound_speed_air(293);
r = sensor_position() / v;

%% Init database
db = Database();

%% Load signal
[y, fs] = db.getAudioData(1);

%% Init angles and lags.
phi = linspace(0, 2 * pi, 361);
% theta = zeros(size(phi));
% theta = deg2rad(linspace(0, 90, 91));
theta = 0;
[Phi, Theta] = meshgrid(phi, theta);
tau = -r.' * direction(Phi(:).', Theta(:).') * fs;

%% Beamforming
S = load('data/sig.mat', 'sig');    % Load muzzleflash signature signal
tic;
y1 = signal_process(y, tau, [0, Inf], S.sig);
toc;

t = (0 : size(y1, 2) - 1) / fs;
clf;
imagesc(t, rad2deg(phi), y1);
hold on;
grid on;
colorbar;
[~, I] = sort(y1, 'descend');
plot(t, rad2deg(phi(I(1, :))), '.k');
ylabel 'angle, ^\circ';
xlabel 'time, s';
legend 'detected angle of arrival';