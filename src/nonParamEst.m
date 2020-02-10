function [H, D] = nonParamEst()
    % Estimate the PDF of delta using non parametric estimation
    % techniques of histogram, parzen window, gaussian kernel and
    % knn.

    coins = [0.1 0.2 0.3 0.4 0.5];
    d = 100;
    
    % bin widths to try
    h_s = 1:1:10;
    
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
        deltas = zeros(sum((1:1:5).*factors(k)), d, num_avg);
        for i = 1:num_avg
            deltas(:, :, i) = genDelta(coins, d, factors(k));
        end

        % histogram method
        div = zeros(length(h_s), 1);
        for i = 1:length(h_s)
            for j = 1:num_avg
                delta = deltas(:, :, j);
                [p, x, h, n] = histEstimate(delta, h_s(i));
                div(i) = div(i) + kl_dist(true_x, true_p, x, p./h);

                %figure;
                %bar(x, p./h, 'barwidth', 1);
                %hold on;
                %plot(true_x, true_p);
            end
            h_s(i)
        end

        H(k, :) = h_s;
        D(k, :) = div./num_avg;
        %hold on;
        %plot(h_s, div./num_avg);
    end
end
