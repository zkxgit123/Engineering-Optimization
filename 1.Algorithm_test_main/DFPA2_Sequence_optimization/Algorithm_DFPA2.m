function [Optimum_seq_fpa] = Algorithm_DFPA2(kk1,init_pop,M,V,Num_ite,group_size,P_poll,Ref_point,Buf,Obj)
%% 初始种群非支配排序
seq_iteration_fpa = cell(Num_ite,1);
init_pop_dom = non_domination_sort_mod(init_pop, M, V); % 非支配排序
seq_iteration_fpa{1,1} = init_pop_dom; %存放初始种群
loc_front = V+M+1;  % 排序等级所在位置
Optimum_seq_fpa = cell(Num_ite,3);
Optimum_seq_fpa{1,1} = Seq_optimum_set(init_pop_dom,loc_front,1);% 搜索等级为1的解保存至Optimum_swam中
Optimum_seq_fpa{1,2} = exam_hypervolume(Optimum_seq_fpa{1,1},Ref_point);
%% FPA迭代优化
for ite=2:Num_ite
    fprintf('正在进行DFPA算法第%d次运算,第%d次迭代,',kk1,ite);
    tic
    Parent_sequence = seq_iteration_fpa{ite-1,1};   % 前一步父代种群
    Children_sequence = pollination(Parent_sequence,P_poll,Buf);% 输出49个优化种群
    % 授粉种群与初始种群放在一起重新/进行非支配排序，去除重复解，选取前50个解，作为下一次花授粉的种群；
    Parent_sequence(:,V+M+1:V+M+2)=[]; % 清除评价，准备交叉变异
    iteration_group = cell(2*group_size-1, V+M); % 分配空间
    iteration_group(1:group_size,1:M+V)=Parent_sequence; % 存入父代
    iteration_group(group_size+1:2*group_size-1,1) = Children_sequence; % 存入子代
    for jj1 = group_size+1 : 2*group_size-1
        res=new_objective(iteration_group{jj1,1},Obj); % 目标函数赋值
        iteration_group{jj1,2}=res(1,1);
        iteration_group{jj1,3}=res(1,2);
        iteration_group{jj1,4}=res(1,3);
        iteration_group{jj1,5}=res(1,4);
    end
    iteration_group_re = reduce_repetition(iteration_group); % 删除重复个体
    % 补充解集
    iteration_group_non = non_domination_sort_mod(iteration_group_re, M, V); % pareto排序
    seq_iteration_fpa{ite,1} = iteration_group_non(1:group_size,:); % 选择前50%的较优解继续迭代
    %% 提取排序等级为1的解
    Optimum_seq_fpa{ite,1} = Seq_optimum_set(seq_iteration_fpa{ite,1},loc_front,1);% 搜索等级为1的解保存至Optimum_swam中
    Optimum_seq_fpa{ite,2} = exam_hypervolume(Optimum_seq_fpa{ite,1},Ref_point); % 求解第hv次迭代的HV值
    toc
    Optimum_seq_fpa{ite,3} = toc;
end
end

