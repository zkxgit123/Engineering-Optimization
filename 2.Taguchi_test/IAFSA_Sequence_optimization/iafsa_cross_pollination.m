function seq_result = iafsa_cross_pollination(cur_individual,best_individual,Buf)
%% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
max_delay_order = Buf(1,3); % 订单需求最大延误量
Order_seq = cur_individual(:,1:6); % 提取父代总装车间序列
%% 减法操作
P1_maker_ass = cur_individual(:,29); % 父代1的选择序列标记
P2_maker_ass = best_individual(:,29); % 父代2的选择序列标记
[E_a,a_t] = iafsa_subtraction(P1_maker_ass,P2_maker_ass);% 总装序列次数统计
%% 加法操作
% 交叉点选择
if  a_t ~= 0  % 序列不相同则对其进行交叉
    t=1;
    legal_seq = 0;
    while legal_seq == 0 && t <10
        % 交叉点选择
        L=rand(1,2);  % 生成一个随机数并限制在（0，1）之间，
        T_1 = min(ceil(L*a_t)); % 交叉位置1
        T_2 = max(ceil(L*a_t)); % 交叉位置2
        C_Assembly_maker = P1_maker_ass;
        for j3 = T_1:T_2
            C_Assembly_maker(E_a(j3,1),1) = E_a(j3,2);
        end
        % 总装序列合法
        C_Assembly = iafsa_merge_operation(Order_seq,C_Assembly_maker);
        delay_order =  Order_seq(:,1)-C_Assembly(:,1);
        delay_time_order = max(delay_order);
        if delay_time_order <= max_delay_order
           legal_seq = 1;
        end
        t=t+1;
    end
else % 序列相同则不进行交叉
    C_Assembly = cur_individual(:,7:12);
    C_Assembly_maker = cur_individual(:,29);
end
%% 个体生成
%% 构建涂装车间生产序列
[C_Painting,final_col_record] = GF_buffer_fill_release(C_Assembly,Lane_size,max_lane_num,3);% 涂装序列
%% 构建焊接车间生产序列
[C_Welding,final_mod_record] = GF_buffer_fill_release(C_Painting,Lane_size,max_lane_num,2);% 焊接序列
Children = [Order_seq C_Assembly C_Painting C_Welding final_col_record final_mod_record C_Assembly_maker];
seq_result = Children;
end
