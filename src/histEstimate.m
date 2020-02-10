function [P, X, B, N] = histEstimate(deltas, h)

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
    idx = floor((num_heads(i) - miny) / h) + 1;
    P(idx) = P(idx) + 1;
end


% normalize H
P = P ./ num_samples;
B = h;
N = num_bins;

end
