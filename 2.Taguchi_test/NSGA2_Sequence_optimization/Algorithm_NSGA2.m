function [Optimum_seq_nsga2] = Algorithm_NSGA2(kk1,init_pop,M,V,Num_ite,group_size,P_cross,P_muta,Ref_point,Buf,Obj)
%% 初始种群非支配排序
individual = init_pop{1,1};
OrderSeq = individual(:,1:6);
init_pop_dom = non_domination_sort_mod(init_pop, M, V); % 输出进行排序的优化种群
seq_iteration_nsga2 = cell(Num_ite,2);
seq_iteration_nsga2{1,1} = init_pop_dom; %存放初始种群
%% 迭代优化
for ite=2:Num_ite
    fprintf('正在进行NSGA-II算法第%d次运算,第%d次迭代,',kk1,ite);
    tic
    tour=2;% 二元锦标赛机制
    Parent_sequence = nsga2_tournament_selection(seq_iteration_nsga2{ite-1,1},group_size,tour);
    Parent_sequence(:,V+M+1:V+M+2)=[]; % 清除评价，准备交叉变异
    after_cross_over = nsga2_cross_operator(Parent_sequence,P_cross,Buf); % 交叉
    after_mutation = nsga2_mutation_operator(after_cross_over,P_muta,Buf,Obj); % 变异
    % 精英策略
    iteration_group=cell(2*group_size, V+M); % 分配空间
    iteration_group(1:group_size,:)=seq_iteration_nsga2{ite-1,1}(:,1:(V+M)); % 存入父代
    iteration_group(group_size+1:2*group_size,:)=after_mutation; % 存入子代
    iteration_group = reduce_repetition(iteration_group); % 降低重复个体
    % 补充解集
    iteration_group = add_sequence(OrderSeq,iteration_group,group_size,Buf,Obj);
    iteration_group = non_domination_sort_mod(iteration_group, M, V); % pareto排序
    seq_iteration_nsga2{ite,1} = iteration_group(1:group_size,:); % 选择前50%的较优解继续迭代
    toc
end
%% 提取排序等级为1的解
loc_front = V+M+1;  % 排序等级所在位置
Optimum_seq_nsga2 = cell(Num_ite,2);
for ite=1:Num_ite
    Optimum_seq_nsga2{ite,1} = Seq_optimum_set(seq_iteration_nsga2{ite,1},loc_front,1);  % 搜索等级为1的解保存至Optimum_seq_fpa中
    Optimum_seq_nsga2{ite,2} = exam_hypervolume(Optimum_seq_nsga2{ite,1},Ref_point); % 求解第hv次迭代的HV值
end
end
