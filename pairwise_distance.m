function d = pairwise_distance(r_src, r_rec)
    N_rec = size(r_rec, 1);
    N_src = size(r_src, 1);
    d = zeros(N_src, N_rec);
    
    for i_src = 1 : N_src
        for i_rec = 1 : N_rec
            d(i_src, i_rec) = norm(r_rec(i_rec, :) - r_src(i_src, :));
        end
    end
end