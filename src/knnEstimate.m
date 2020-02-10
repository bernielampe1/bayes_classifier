function [P, X, B, N] = knnEstimate(deltas, K)

h = 1;

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
for i = 1:length(X)
    [nearest_idxs, D] = knnsearch(num_heads, X(i)+0.5, 'K', K);
    V = max(D);
    
    kp = 0;
    for j = 1:length(num_heads)
        if num_heads(j) > X(i)-V
            if num_heads(j) < X(i)+V
                kp = kp + 1;
            end
        end
    end
    P(i) = kp / (2*V);
    
    %P(i) = K / (2*V);
end

P = P ./ num_samples;
B  = h;
N = num_bins;
end
