function [P, X, B, N] = emEstimate(deltas, n, h)

% returns estimated pmf, sample positions, sample width and number of samples

% compute number of heads
num_heads = sum(deltas, 2)';
maxy = max(num_heads);
miny = min(num_heads);


% init the thetas by placing them uniformly through the domain
q = ((maxy - miny) / (n - 1));
init = miny:q:maxy;
[label, model, llh] = emgm(num_heads, init);

X = miny:h:maxy;
P = zeros(1,length(X));
for i = 1:length(model.mu)
    y = model.weight(i) * normpdf(X, model.mu(i), sqrt(model.Sigma(i)));
    P = y + P;
end

P = P';
B = h;
N = numel(X);

end
