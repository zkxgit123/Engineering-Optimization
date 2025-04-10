function seq_result = iafsa_cross_pollination(cur_individual,best_individual,Buf)
%% ��������
Lane_size = Buf(1,1);  % ��������
max_lane_num = Buf(1,2); % �����������������
max_delay_order = Buf(1,3); % �����������������
Order_seq = cur_individual(:,1:6); % ��ȡ������װ��������
%% ��������
P1_maker_ass = cur_individual(:,29); % ����1��ѡ�����б��
P2_maker_ass = best_individual(:,29); % ����2��ѡ�����б��
[E_a,a_t] = iafsa_subtraction(P1_maker_ass,P2_maker_ass);% ��װ���д���ͳ��
%% �ӷ�����
% �����ѡ��
if  a_t ~= 0  % ���в���ͬ�������н���
    t=1;
    legal_seq = 0;
    while legal_seq == 0 && t <10
        % �����ѡ��
        L=rand(1,2);  % ����һ��������������ڣ�0��1��֮�䣬
        T_1 = min(ceil(L*a_t)); % ����λ��1
        T_2 = max(ceil(L*a_t)); % ����λ��2
        C_Assembly_maker = P1_maker_ass;
        for j3 = T_1:T_2
            C_Assembly_maker(E_a(j3,1),1) = E_a(j3,2);
        end
        % ��װ���кϷ�
        C_Assembly = iafsa_merge_operation(Order_seq,C_Assembly_maker);
        delay_order =  Order_seq(:,1)-C_Assembly(:,1);
        delay_time_order = max(delay_order);
        if delay_time_order <= max_delay_order
           legal_seq = 1;
        end
        t=t+1;
    end
else % ������ͬ�򲻽��н���
    C_Assembly = cur_individual(:,7:12);
    C_Assembly_maker = cur_individual(:,29);
end
%% ��������
%% ����Ϳװ������������
[C_Painting,final_col_record] = GF_buffer_fill_release(C_Assembly,Lane_size,max_lane_num,3);% Ϳװ����
%% �������ӳ�����������
[C_Welding,final_mod_record] = GF_buffer_fill_release(C_Painting,Lane_size,max_lane_num,2);% ��������
Children = [Order_seq C_Assembly C_Painting C_Welding final_col_record final_mod_record C_Assembly_maker];
seq_result = Children;
end
