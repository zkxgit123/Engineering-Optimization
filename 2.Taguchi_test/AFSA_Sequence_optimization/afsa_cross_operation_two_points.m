function Children_1 = afsa_cross_operation_two_points(Parent_A,Parent_B,P_cross,Buf)
%% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
max_delay_order = Buf(1,3); % 订单需求最大延误量
%% 交叉变异
p1 = rand(1);% 生成变异概率
if p1 < P_cross && ~isequal(Parent_A,Parent_B) % 90%的概率进行交叉
    % 子代个体的生成
    Order_seq = Parent_A(:,1:6); 
    P1_assembly = Parent_A(:,7:12); 
    P2_assembly = Parent_B(:,7:12); 
    t = 1;
    legal_seq = 0;
    while legal_seq == 0 && t <20
        % 构建总装车间生产序列
        [C1_assembly,C2_assembly] = afsa_cross_ox(P1_assembly,P2_assembly);
        % 总装序列合法
        delay_order(:,1) =  Order_seq(:,1)-C1_assembly(:,1);
        delay_order(:,2) =  Order_seq(:,1)-C2_assembly(:,1);
        max_delay_time_order = max(delay_order);
        if max_delay_time_order <= max_delay_order
            legal_seq=1;
        end
        t=t+1;
    end
    % 构建涂装车间生产序列
    [final_col_seq,final_col_record]= GF_buffer_fill_release(C1_assembly,Lane_size,max_lane_num,3);% 涂装序列
    % 构建焊接车间生产序列
    [final_mod_seq,final_mod_record]= GF_buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2); % 焊接序列
    % 子代个体
    Children_1 = [Order_seq C1_assembly final_col_seq final_mod_seq final_col_record final_mod_record];
else
    Children_1 = Parent_A; % 子代种群
end

end