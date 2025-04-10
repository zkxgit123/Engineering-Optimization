function [after_mutation] = nsga2_mutation_operator(after_cross_over,P_muta,Buf,Obj)
%% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
max_delay_order = Buf(1,3); % 订单需求最大延误量
[Group_size,~] = size(after_cross_over);% 种群数量
after_mutation=cell(Group_size,5); % 储存变异后的解
for ii2=1:Group_size
    p_mutation=rand(1);% 个体变异概率
    if   p_mutation <= P_muta   % 概率小于20%时，个体变异
        temp_individual = after_cross_over{ii2,1};
        Order_seq = temp_individual(:,1:6); 
        P1_assembly = temp_individual(:,7:12); 
        [N,~] = size(P1_assembly);
        legal_seq = 0;
        while legal_seq == 0
            % 构建总装车间生产序列
            L = sort(rand(1,2));%         n_points = 2;
            L_c = ceil(L*N); % 变异位置
            C1_assembly = P1_assembly(:,:);
            C1_assembly(L_c(1,1),:) = P1_assembly(L_c(1,2),:);
            C1_assembly(L_c(1,2),:) = P1_assembly(L_c(1,1),:);
            % 总装序列合法
            delay_order =  Order_seq(:,1) - C1_assembly(:,1);
            max_delay_time_order = max(delay_order);
            if max_delay_time_order <= max_delay_order
                legal_seq=1;
            end
        end
        % 构建涂装车间生产序列
        [final_col_seq,final_col_record]= GF_buffer_fill_release(C1_assembly,Lane_size,max_lane_num,3);% 涂装序列
        % 构建焊接车间生产序列
        [final_mod_seq,final_mod_record]= GF_buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2); % 焊接序列
        % 子代个体
        Children_1 = [Order_seq C1_assembly final_col_seq final_mod_seq final_col_record final_mod_record];
        after_mutation{ii2,1}=Children_1;
    else
        after_mutation{ii2,1}=after_cross_over{ii2,1};  % 不进行变异
    end
    % 目标函数赋值
    res_obj = new_objective(after_mutation{ii2,1},Obj); % 目标函数赋值
    after_mutation{ii2,2} = res_obj(1,1); % 碳排放量
    after_mutation{ii2,3} = res_obj(1,2); % 生产成本
    after_mutation{ii2,4} = res_obj(1,3); % 物料均衡率
    after_mutation{ii2,5} = res_obj(1,4); % 总拖期延误
end

end
