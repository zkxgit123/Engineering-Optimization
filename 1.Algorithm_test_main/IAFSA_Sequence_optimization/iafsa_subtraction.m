function [E,e_t]=iafsa_subtraction(P1_maker,P2_maker)
    % 序列次数统计
    % P1_maker = cur_individual(:,10); % 父代1的选择序列标记
    % P2_maker = best_individual(:,10); % 父代1的选择序列标记
    [N,~] = size(P1_maker); % 订单长度
    E = zeros(0,0);
    e_t=1;     % 更换次数
    for ii2=1:N % 记录涂装所需
        if P1_maker(ii2,1)~=P2_maker(ii2,1)   % 比较相同位置两订单号是否相同
           E(e_t,1) = ii2;
           E(e_t,2) = P2_maker(ii2,1);% 标记
           e_t=e_t+1;
        end
    end
    e_t = e_t-1; % 实际交换次数，由于赋值需求需要-1
end
