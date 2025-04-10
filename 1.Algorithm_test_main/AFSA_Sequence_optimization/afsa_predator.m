function [final_individual] = afsa_predator(x_current,n_try,P_cross_swam,Buf,Obj)
V = 1;
M = 4; % 目标函数量
individual = x_current{1,1};
OrderSeq = individual(:,1:6);
%% 觅食行为
t = 1;
Q_prey = cell(0,0);
while t <= n_try
    % 随机生成1个序列
    x_p1 = init_pop_maker(OrderSeq,Buf);
    x_cross = afsa_cross_operation_two_points(individual,x_p1,P_cross_swam,Buf); % 交叉之后得到的子序列
    Q_prey_object = new_objective(x_cross,Obj);
    Q_prey{1,2} = Q_prey_object(1,1);% 碳排放量
    Q_prey{1,3} = Q_prey_object(1,2);% 生产成本
    Q_prey{1,4} = Q_prey_object(1,3);% 物料均衡率
    Q_prey{1,5} = Q_prey_object(1,4);% 总拖期延误
    s1 = afsa_dominant_judgement(x_current,Q_prey,M,V);
    if  s1~=1   %若为1，则当前个体更优，若为2则检索个体为优，若为0则互不支配
        final_individual = x_cross;
        break;
    else
     t=t+1;
    end
end
%% 随机行为
if t > n_try  % 尝试n_try之后若未找到更优的解，则进行随机行为
    final_individual = init_pop_maker(OrderSeq,Buf);
end
end


