function seq_result = self_pollination2(cur_individual,middle_1,middle_2,Buf)
Lane_size=Buf(1);
max_lane_num=Buf(2);
%% 减法操作
P1_maker_mod = middle_1(:,29); % 父代1的选择序列标记
P2_maker_mod = middle_2(:,29); % 父代2的选择序列标记
P_maker_mod = cur_individual(:,29); % 父代1的选择序列标记
[E_a,a_t] = DFPA2_subtraction(P1_maker_mod,P2_maker_mod);% 总装序列次数统计
Order_seq = cur_individual(:,1:6); % 提取父代总装车间序列
%% 加法操作
if a_t ~= 0
    L = rand(1,2);  % 生成一个随机数并限制在（0，1）之间，
    T_1 = min(ceil(L*a_t)); % 交叉位置1
    T_2 = max(ceil(L*a_t)); % 交叉位置2
    C_moding_maker = P_maker_mod;
    for j3 = T_1:T_2
        C_moding_maker(E_a(j3,1),1) = E_a(j3,2);
    end
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
