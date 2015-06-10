v = 330;
r_rec = [0, 0; 1000, 0; 0, 500];
r_src = [500, 800];
sigma_t = 0.1;
sigma_r = 3;

N_rec = size(r_rec, 1);
t = pairwise_distance(r_src, r_rec) / v;
t = t + normrnd(0, sigma_t, size(t));

[x, y] = meshgrid(0 : 1000, 0 : 1000);
r = [x(:), y(:)];

mu = repmat(t, size(r, 1), 1) - pairwise_distance(r, r_rec + normrnd(0, sigma_r, size(r_rec))) / v;
mu_bar = mean(mu, 2);
mu_var = sum((mu - repmat(mu_bar, 1, size(mu, 2))).^2, 2);
L = exp(-mu_var / (2 * sigma_t^2));
L = L / sum(L);

contourf(x, y, reshape(L, size(x))); colorbar
axis equal

r_est = r.' * L