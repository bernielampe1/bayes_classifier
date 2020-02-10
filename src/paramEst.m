function [H, D] = paramEst()
    % number of gaussians to try
    h_s = 2:1:10;
    
    % compute the true distrobution
    true_x = 0:1:100;
    true_p = trueDist(true_x);
    
    % number of times to generate data and average the kl distance
    num_avg = 10;

    % factors is related to the number of samples
    factors = 50:50:250;

    H = zeros(length(factors), length(h_s));
    D = zeros(length(factors), length(h_s));

    for k = 1:length(factors)
        % compute the data sets up front for all the averaging
        deltas = zeros(sum((1:1:5).*factors(k)), 100, num_avg);
        for i = 1:num_avg
            deltas(:, :, i) = genDelta([0.1 0.2 0.3 0.4 0.5], 100, factors(k));
        end

        % histogram method
        div = zeros(length(h_s), 1);
        for i = 1:length(h_s)
            for j = 1:num_avg
                delta = deltas(:, :, j);
                [p, x, h, n] = emEstimate(delta, h_s(i), 1);
                div(i) = div(i) + kl_dist(true_x, true_p, x, p./h);

                %figure;
                %bar(x, p./h, 'barwidth', 1);
                %hold on;
                %plot(true_x, true_p);
            end
            i
        end

        H(k, :) = h_s;
        D(k, :) = div./num_avg;
        %hold on;
        %plot(h_s, div./num_avg);
    end
end
