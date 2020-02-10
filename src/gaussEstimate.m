function [P, X, B, N] = gaussEstimate(deltas, h)

% returns estimated pmf, sample positions, sample width and number of samples

% compute number of heads
num_heads = sum(deltas, 2);
miny = min(num_heads);
maxy = max(num_heads);

X = miny:h:maxy;
P = normpdf(X, mean(num_heads), sqrt(var(num_heads)));

B  = h;
N = numel(X);

end
