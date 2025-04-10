function seq_result = cross_pollination2(cur_individual,best_individual,Buf,ass_seq0)
%% ��������
Lane_size = Buf(1,1);  % ��������
max_lane_num = Buf(1,2); % �����������������
Order_seq = cur_individual(:,1:6); % ��ȡ������װ��������
%% ��������
P1_maker_ass = cur_individual(:,29); % ����1��ѡ�����б��
P2_maker_ass = best_individual(:,29); % ����2��ѡ�����б��
[E_a,a_t] = DFPA2_subtraction(P1_maker_ass,P2_maker_ass);% ��װ���д���ͳ��
%% �ӷ�����
if a_t ~= 0
    % �����ѡ��
    L = rand(1,2);  % ����һ��������������ڣ�0��1��֮�䣬
    T_1 = min(ceil(L*a_t)); % ����λ��1
    T_2 = max(ceil(L*a_t)); % ����λ��2
    C_moding_maker = P1_maker_ass;
    for j3 = T_1:T_2
        C_moding_maker(E_a(j3,1),1) = E_a(j3,2);
    end
    % ��װ���кϷ�
    C_moding = iafsa_merge_operation(Order_seq,C_moding_maker);
else % ������ͬ�򲻽��н���
    C_moding = cur_individual(:,7:12);
    C_moding_maker = cur_individual(:,29);
end
% ����Ϳװ������������
[C_col_seq,new_wbs_lane]= GF_buffer_fill_release(C_moding,Lane_size,max_lane_num,3);
% ������װ������������
[C_ass_seq,new_pbs_lane]=GF_buffer_fill_release(C_col_seq,Lane_size,max_lane_num,2);
seq_result=[Order_seq,C_moding,C_col_seq,C_ass_seq,new_wbs_lane,new_pbs_lane,C_moding_maker];
end
