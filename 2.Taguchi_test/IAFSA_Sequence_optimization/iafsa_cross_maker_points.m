function final_maker = iafsa_cross_maker_points(c1_maker,E,e_t)
    final_maker = c1_maker;
    L = zeros(1,2);
    for i=1:2
        beta = 1.5;
        sigma_u = (gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
        sigma_v = 1;
        u = normrnd(0,sigma_u);
        v = normrnd(0,sigma_v);
        s = u/(abs(v))^(1/beta);
        Levy=beta*gamma(beta)*sin(pi*beta/2)/pi/s^(1+beta);
        le = abs(Levy);
        if le>1
            L(i)=1;
        else
            L(i)=le;  % 这里的L与交换次数t共同决定了该解朝向最优解进化的次数
        end
    end
    L1(1,1) = min(L);
    L1(1,2) = max(L);
    T_p = ceil(L1(1,:)*e_t); % 交叉位置
    for j3 =T_p(1,1):T_p(1,2)
        final_maker(E(j3,1),1) = E(j3,2);
    end
end