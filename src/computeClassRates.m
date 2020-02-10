function computeClassRates()

coins = [0.1 0.2 0.3 0.4 0.5];
h = 1; % optimal from KL dist
num_tests = 1000;

% generate training data
delta = genDelta(coins, 100, 200);

% estimate unconditional probabilities p(x)
%[p, x, h, n] = histEstimate(delta, 3);

% estimate class conditional probabilities p(x|C_k)
delta_c1 = delta(1:200,:);
[p1, x1, h1, n1] = emEstimate(delta_c1, 5, h);

delta_c2 = delta(201:600,:);
[p2, x2, h2, n2] = emEstimate(delta_c2, 5, h);

delta_c3 = delta(600:1200,:);
[p3, x3, h3, n3] = emEstimate(delta_c3, 5, h);

delta_c4 = delta(1201:2000,:);
[p4, x4, h4, n4] = emEstimate(delta_c4, 5, h);

delta_c5 = delta(2001:3000,:);
[p5, x5, h5, n5] = emEstimate(delta_c5, 5, h);

figure;
plot(x1, p1./h1);
hold on
plot(x2, p2./h2);
plot(x3, p3./h3);
plot(x4, p4./h4);
plot(x5, p5./h5);

% classify samples via MLE and MAP
map_correct = 0;
mle_correct = 0;
for i = 1:num_tests
    % choose a random coin
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
    map_probs = mle_probs .* [1, 2, 3, 4, 5] .* 200/3000;
    
    [max_mle, max_index] = max(mle_probs);
    if max_index == c_index
         mle_correct = mle_correct + 1;
    end
    
    [max_map, max_index] = max(map_probs);
    if max_index == c_index
        map_correct = map_correct + 1;
    end
end

% compute classification rate
mle_class_rate = mle_correct / num_tests
map_class_rate = map_correct / num_tests

end
