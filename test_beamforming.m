%% Load signal.
[data, fs] = read_data('data/raw/002_00h_0m_47s');
data = data(:, 75000:100000);
%data = data(:, 300000:400000);
% plot_xcorr(data, 150);
plot(data.');

%% Load signal.
[data, fs] = read_data('data/raw/002_00h_0m_55s');
%data = data(:, 75000:100000);
%data = data(:, 300000:400000);
% plot_xcorr(data, 150);
plot(data.');

%% Init angles and lags.
r = sensor_position();
theta = linspace(0, 2 * pi, 100);
v = 340;
tau = signal_lag(r / v * fs, theta);

%% Delay-and-sum
y = delay_and_sum(data1_noisy, -round(tau));
p = y.^2;
p_sum = mean(p, 2);
% polar(theta.', (p_sum - min(p_sum)) / (max(p_sum) - min(p_sum)));
polar(theta.', p_sum);
