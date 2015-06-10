function [logL, w_begin] = LogL(this, y)
    % Calculate log likelihoof of data y for angles theta
    % sigma_n =  sqrt(E{n^2}) -- std of noise.
    
    % Number of channels
    K = size(this.tau, 1);
    
    % Number of time steps
    N = size(y, 2);    
    assert(size(y, 1) == K);
    
    nW = floor((N - this.windowLength) / this.windowOffset + 1);
    w_begin = (0 : nW - 1) * this.windowOffset + 1;
    
    logL = zeros(length(this.theta), nW);    
    tau = int16(this.tau);
        
    for iw = 1 : nW
        % Current window range.
        range = w_begin(iw) : w_begin(iw) + this.windowLength - 1;
        
        % Calculate log likelihood for current window.
        logL(:, iw) = log_lik_mex(y(:, range), tau, this.sigma_n);
    end
    
    logL = logL - repmat(logsumexp(logL), size(logL, 1), 1);
end