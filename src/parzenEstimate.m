function [P, X, B, N] = parzenEstimate(deltas, h)

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
        q = H((X(j) - num_heads(i)) / h);
        
        % this is a hack but prevents double counting
        if q == 1
            P(j) = P(j) + 1;
            break
        end
    end
end

P = P ./ num_samples;
B  = h;
N = num_bins;
end

function x = H(u)
    x = 0;
    if abs(u) <= 0.5
        x = 1;
    end
end
