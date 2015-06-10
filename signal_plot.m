function signal_plot(y)
% Plot all channels of the signal individually.
    K = size(y, 1);
    
    for k = 1 : K
        subplot(K, 1, k);
        plot(y(k, :));
        grid on;
    end
end

