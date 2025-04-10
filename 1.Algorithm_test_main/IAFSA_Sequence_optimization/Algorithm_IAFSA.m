function [Optimum_seq_iafsa] = Algorithm_IAFSA(kk1,init_pop,M,V,Num_ite,group_size,P_swam,delta,visual_range,Ref_point,Buf,Obj)
%% 对初始种群提取排序等级为1的解
Optimum_seq_iafsa = cell(Num_ite,2);
init_pop_dom = non_domination_sort_mod(init_pop, M, V);  % 非支配排序
loc_front = M+V+1; % 排序等级所在位置
Q = Seq_optimum_set(init_pop_dom,loc_front,1);% 搜索等级为1的解保存至Optimum_swam中
Q = Q(:,1:M+V); % 清除pareto等级
Optimum_seq_iafsa{1,1} = Q;
% Optimum_swarm = Seq_optimum_set(init_pop_dom,loc_front,1);% 搜索等级为1的解保存至
% Optimum_seq_iafsa{1,1} = Optimum_swarm;% 搜索等级为1的解保存至Optimum_swam中
loc_swam = init_pop; % 当前鱼群位置
%% 人工鱼群算法
% 开始迭代
for ite = 2:Num_ite % 迭代数量判断
    fprintf('正在进行IAFSA算法第%d次运算,第%d次迭代,',kk1,ite);
    tic
    temp_new_swam = cell(0,0);  % 定义一个临时数组，用来存放前进后的鱼群
    for s1=1:group_size  % 对每个鱼都分析
        random_operator = rand(1);
%         visual_range = 2*ceil(group_size*rand(1)/4+group_size/5);
        n_try = ceil(group_size/5) ;
        if  random_operator <= P_swam   % 生成一个随机数，随机进行群聚和追尾行为
            temp_next_state = iafsa_swarm_behavior(s1,loc_swam,delta,visual_range,n_try,Buf,Obj);   % 群聚行为
        else                       
            temp_next_state = iafsa_follow_behavior(s1,loc_swam,delta,visual_range,n_try,Buf,Obj);  % 追尾行为
        end
        temp_new_swam = [temp_new_swam;temp_next_state];% 保存种群
    end
    new_swam = reduce_repetition(temp_new_swam); % 降低重复个体
    loc_swam = iafsa_inferior_swam(new_swam,M,V,group_size);    
    % 保存新的非劣解
    renewed_Q = [Q;loc_swam]; % 保存新生成的非劣解
    renewed_Q = reduce_repetition(renewed_Q); % 降低重复个体
    new_swam_dom = non_domination_sort_mod(renewed_Q,M,V);
    Optimum_swarm = Seq_optimum_set(new_swam_dom,loc_front,1);% 搜索等级为1的解保存至
    Q = Optimum_swarm(:,1:M+V); % 清除pareto等级
    if size(Q,1)<=group_size
        Optimum_seq_iafsa{ite,1} = Q;% 搜索等级为1的解保存至Optimum_swam中
    else
        Optimum_seq_iafsa{ite,1} = Q(1:group_size,:);% 搜索等级为1的解保存至Optimum_swam中
    end
%     Q_swarm_dom = non_domination_sort_mod(loc_swam,M,V);
%     Optimum_swarm = Seq_optimum_set(Q_swarm_dom,loc_front,1);% 搜索等级为1的解保存至
%     Optimum_seq_iafsa{ite,1} = Optimum_swarm;% 搜索等级为1的解保存至Optimum_swam中
    toc
end
%% HV指标评价
for ite=1:Num_ite
    Optimum_seq_iafsa{ite,2} = exam_hypervolume(Optimum_seq_iafsa{ite,1},Ref_point); % 求解第hv次迭代的HV值
end
end