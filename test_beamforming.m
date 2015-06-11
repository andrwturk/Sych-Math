%% Load signal.
[data, fs] = read_data('data/raw/ak-47-left-100m');
data = data(:, 300000:400000);
plot_xcorr(data, 150);

%% Init angles and lags.
r = sensor_position();
theta = linspace(0, 2 * pi, 360);
v = 340;
tau = signal_lag(r / v * fs, theta);

%% Delay-and-sum
y1 = delay_and_sum(data, -round(tau));
p = mean(y1.^2, 2);
polar(theta.', p);