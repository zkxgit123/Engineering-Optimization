function [Optimum_seq_afsa] = Algorithm_AFSA(kk1,init_pop,M,V,Num_ite,group_size,P_swam_1,delta,visual_range,Ref_point,Buf,Obj)
%% 对初始种群提取排序等级为1的解
Optimum_seq_afsa = cell(Num_ite,2);
init_pop_dom = non_domination_sort_mod(init_pop, M, V);  % 非支配排序
loc_front = M+V+1; % 排序等级所在位置
Q = Seq_optimum_set(init_pop_dom,loc_front,1);% 搜索等级为1的解保存至Optimum_swam中
Q = Q(:,1:M+V); % 清除pareto等级
Optimum_seq_afsa{1,1} = Q;
% Optimum_swarm = Seq_optimum_set(init_pop_dom,loc_front,1);% 搜索等级为1的解保存至
% Optimum_seq_afsa{1,1} = Optimum_swarm;% 搜索等级为1的解保存至Optimum_swam中
P_cross_swarm = 0.9;
cur_swarm = init_pop;
%% 人工鱼群算法
%% 开始迭代
for ite = 2:Num_ite % 迭代数量判断
    tic
    fprintf('正在进行AFSA算法第%d次运算,第%d次迭代,',kk1,ite);
    %% 人工鱼群
    all_temp_swarm = [];
    for ii1=1:group_size
        random_operator=rand(1);
%         visual_range = 2*ceil(group_size*rand(1)/4+group_size/8);
        n_try = ceil(group_size/5) ;
        if  random_operator<=P_swam_1 % 随机进行群聚行为或跟随行为
            temp_Q = afsa_swarm_behavior(ii1,cur_swarm,delta,visual_range,P_cross_swarm,n_try,Buf,Obj);
        else
            temp_Q = afsa_follow_behavior(ii1,cur_swarm,delta,visual_range,P_cross_swarm,n_try,Buf,Obj);
        end
        % 保存种群
        all_temp_swarm = [all_temp_swarm;temp_Q];
    end
   %% 种群处理
    next_swarm = reduce_repetition(all_temp_swarm); % 降低重复个体
    cur_swarm = afsa_inferior_swam(next_swarm,M,V,group_size);    
    Q_swarm_dom = non_domination_sort_mod(cur_swarm,M,V);
    Optimum_swarm = Seq_optimum_set(Q_swarm_dom,loc_front,1);% 搜索等级为1的解保存至
    Q = Optimum_swarm(:,1:M+V); % 清除pareto等级
    if size(Q,1)<=group_size
        Optimum_seq_afsa{ite,1} = Q;% 搜索等级为1的解保存至Optimum_swam中
    else
        Optimum_seq_afsa{ite,1} = Q(1:group_size,:);% 搜索等级为1的解保存至Optimum_swam中
    end
    toc
end
%% HV指标评价
for ite=1:Num_ite
    Optimum_seq_afsa{ite,2} = exam_hypervolume(Optimum_seq_afsa{ite,1},Ref_point); % 求解第hv次迭代的HV值
end
end