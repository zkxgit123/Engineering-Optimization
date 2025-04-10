function seq_result = cross_pollination2(cur_individual,best_individual,Buf,ass_seq0)
%% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
Order_seq = cur_individual(:,1:6); % 提取父代总装车间序列
%% 减法操作
P1_maker_ass = cur_individual(:,29); % 父代1的选择序列标记
P2_maker_ass = best_individual(:,29); % 父代2的选择序列标记
[E_a,a_t] = DFPA2_subtraction(P1_maker_ass,P2_maker_ass);% 总装序列次数统计
%% 加法操作
if a_t ~= 0
    % 交叉点选择
    L = rand(1,2);  % 生成一个随机数并限制在（0，1）之间，
    T_1 = min(ceil(L*a_t)); % 交叉位置1
    T_2 = max(ceil(L*a_t)); % 交叉位置2
    C_moding_maker = P1_maker_ass;
    for j3 = T_1:T_2
        C_moding_maker(E_a(j3,1),1) = E_a(j3,2);
    end
    % 总装序列合法
    C_moding = iafsa_merge_operation(Order_seq,C_moding_maker);
else % 序列相同则不进行交叉
    C_moding = cur_individual(:,7:12);
    C_moding_maker = cur_individual(:,29);
end
% 构建涂装车间生产序列
[C_col_seq,new_wbs_lane]= GF_buffer_fill_release(C_moding,Lane_size,max_lane_num,3);
% 构建总装车间生产序列
[C_ass_seq,new_pbs_lane]=GF_buffer_fill_release(C_col_seq,Lane_size,max_lane_num,2);
seq_result=[Order_seq,C_moding,C_col_seq,C_ass_seq,new_wbs_lane,new_pbs_lane,C_moding_maker];
end
