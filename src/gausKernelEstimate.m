function [P, X, B, N] = gausKernelEstimate(deltas, h)

% returns estimated pmf, bin positions, binwidth and number of bins

% compute number of heads
num_heads = sum(deltas, 2);
num_samples = length(num_heads);
miny = min(num_heads);
maxy = max(num_heads);

% compute number of bins needed to achieve desired width
num_bins = ceil((maxy - miny) / h);

X = miny:h:maxy;
P = zeros(length(X), 1);
for i = 1:num_samples
    for j = 1:num_bins
        q = exp(-(X(j) - num_heads(i))^2 / (2*(h^2)));
        P(j) = P(j) + q;
    end
end

P = P ./ sqrt(2*pi*(h^2)) .* h;
P = P ./ num_samples;
B  = h;
N = num_bins;
end