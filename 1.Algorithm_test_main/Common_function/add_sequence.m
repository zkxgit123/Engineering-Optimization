function add_seq = add_sequence(OrderSeq,iteration_group,group_size,Buf,Obj)
% OrderSeq = readmatrix('orderfix.xlsx');%随机初始化订单序列
[num,~]=size(iteration_group);
if num < group_size
    for jj1 = num+1:group_size
        individual = init_pop_maker(OrderSeq,Buf); % 初始种群
        res_obj = new_objective(individual,Obj); % 目标函数赋值
        iteration_group{jj1,1}= individual;
        iteration_group{jj1,2} = res_obj(1,1); % 碳排放量
        iteration_group{jj1,3} = res_obj(1,2); % 生产成本
        iteration_group{jj1,4} = res_obj(1,3); % 物料均衡率
        iteration_group{jj1,5} = res_obj(1,4); % 总拖期延误
    end
    add_seq = iteration_group(:,:);
else
    add_seq = iteration_group(:,:);
end
end

