function signal_plot(y, fs, t_range)
% Plot all channels of the signal individually.
    K = size(y, 1);
    
    if nargin < 2 || isempty(fs)
        t = 1 : size(y, 2);
    else
        t = (0 : size(y, 2) - 1) / fs;
    end
    
    if nargin >= 3
        assert(isvector(t_range) && length(t_range) == 2);
        ind = t >= t_range(1) & t <= t_range(2);
    else
        ind = 1 : length(t);
    end       
    
    for k = 1 : K
        subplot(K, 1, k);
        hold on;
        plot(t(ind), y(k, ind));
        grid on;
    end
end

