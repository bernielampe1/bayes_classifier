function d = kl_dist(P_X, P_P, Q_X, Q_P)

    q_p = interp1(Q_X, Q_P, P_X)';
    p_p = P_P;

    p_p(isnan(p_p) | ~isfinite(p_p)) = 0;
    q_p(isnan(q_p) | ~isfinite(q_p)) = 0;

    l = p_p .* log2(p_p ./ q_p);
    idxs = find(isfinite(l) & ~isnan(l));
    d = sum(l(idxs));    
    
    p_p = interp1(P_X, P_P, Q_X)';
    q_p = Q_P;
    
    p_p(isnan(p_p) | ~isfinite(p_p)) = 0;
    q_p(isnan(q_p) | ~isfinite(q_p)) = 0;

    l = q_p .* log2(q_p ./ p_p);
    idxs = find(isfinite(l) & ~isnan(l));
    d = d + sum(l(idxs));
end
