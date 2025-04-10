function final_maker = nsga2_cross_maker_points(c1_maker,E,e_t)
    L1=zeros(1,2);
    cross_point = rand(1,2);
    L1(1,1) = min(cross_point);
    L1(1,2) = max(cross_point);
    T_p = ceil(L1(1,:)*e_t); % 交叉位置
    final_maker = c1_maker;
    for j3 = T_p(1,1):T_p(1,2)
        final_maker(E(j3,1),1) = E(j3,2);
    end
end
