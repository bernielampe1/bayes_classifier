function p = trueDist(x)
    p = zeros(length(x), 1);
    for k = 1:1:5
        p = p + (k*200/3000) .* binopdf(floor(x), 100, k/10)';
    end
end
