function [H, MLE_CR, MAP_CR] = graphClassRates()
    h_s = 1:1:10;
    factors = 50:50:250;
    coins = [0.1 0.2 0.3 0.4 0.5];
    num_tests = 100;

    H = zeros(length(factors), length(h_s));
    MLE_CR = zeros(length(factors), length(h_s));
    MAP_CR = zeros(length(factors), length(h_s));

    % pick a number of samples
    for i = 1:length(factors)
        s = factors(i)

        % pick a bin width size
        for j = 1:length(h_s)
            delta = genDelta(coins, 100, s);

                
            % run the test 10 times
            mle_cr = 0;
            map_cr = 0;
            for k = 1:num_tests
               
                [mle_correct, map_correct] = runtests(delta, h_s(j), s, coins);
                mle_cr = mle_cr + mle_correct;
                map_cr = map_cr + map_correct;
            end

            mle_cr = mle_cr / num_tests;
            map_cr = map_cr / num_tests;

            H(i, j) = h_s(j);
            MLE_CR(i, j) = mle_cr;
            MAP_CR(i, j) = map_cr;
            j
        end
    end
end

function [map_correct, mle_correct] = runtests(delta, h, s, coins)
    mle_correct = 0;
    map_correct = 0;
    num_tests = 10;
    
    [p1, x1, h1, n1] = histEstimate(delta(1:s,:), h);
    [p2, x2, h2, n2] = histEstimate(delta(1*s+1:3*s,:), h);
    [p3, x3, h3, n3] = histEstimate(delta(3*s+1:6*s,:), h);
    [p4, x4, h4, n4] = histEstimate(delta(6*s+1:10*s,:), h);
    [p5, x5, h5, n5] = histEstimate(delta(10*s+1:15*s,:), h);
                
    for l = 1:num_tests
        c_index = randi(5, 1);
        c_prob = coins(c_index);
        new_x = genObservation(100, c_prob);
        num_heads = sum(new_x);

        mle_1 = interp1(x1, p1./h1, num_heads);
        mle_2 = interp1(x2, p2./h2, num_heads);
        mle_3 = interp1(x3, p3./h3, num_heads); 
        mle_4 = interp1(x4, p4./h4, num_heads);
        mle_5 = interp1(x5, p5./h5, num_heads);

        mle_probs = [mle_1, mle_2, mle_3, mle_4, mle_5];
        map_probs = mle_probs .* [1, 2, 3, 4, 5] .* s/3000;

        [max_mle, max_index] = max(mle_probs);
        if max_index == c_index
             mle_correct = mle_correct + 1;
        end

        [max_map, max_index] = max(map_probs);
        if max_index == c_index
            map_correct = map_correct + 1;
        end
    end % end l:num_tests

    mle_correct = mle_correct / num_tests;
    map_correct = map_correct / num_tests;
end
