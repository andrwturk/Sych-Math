function y = logsumexp(x)
    % y = log(sum(exp(x))) without numerical under-/overflows.
    x_max = max(x);
    y = log(sum(exp(x - repmat(x_max, size(x, 1), 1)))) + x_max;
end

