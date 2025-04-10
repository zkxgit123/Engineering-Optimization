function [seq_result]=nsga2_cross_operator(it_sequence,P_cross,Buf) 
%% ��������
Lane_size = Buf(1,1);  % ��������
max_lane_num = Buf(1,2); % �����������������
max_delay_order = Buf(1,3); % �����������������
[Group_size,~] = size(it_sequence);% ��Ⱥ����
cross_sets =cell(Group_size,1);
for cc1 = 1:Group_size/2
    %% ѡȡ����Ⱥ
    Parent_A = it_sequence{2*cc1-1,1}; % ������ȺA(����)
    Parent_B = it_sequence{2*cc1,1};   % ������ȺB(ż��)
    p_cross = rand(1);% ���ɱ������
    if p_cross < P_cross && ~isequal(Parent_A,Parent_B) % 90%�ĸ��ʽ��н���
        % �Ӵ����������
        Order_seq = Parent_A(:,1:6); 
        P1_assembly = Parent_A(:,7:12); 
        P2_assembly = Parent_B(:,7:12); 
        legal_seq = 0;
        while legal_seq == 0
            % ������װ������������
            [C1_assembly,C2_assembly] = nsga2_cross_ox(P1_assembly,P2_assembly);
            % ��װ���кϷ�
            delay_order(:,1) =  Order_seq(:,1)-C1_assembly(:,1);
            delay_order(:,2) =  Order_seq(:,1)-C2_assembly(:,1);
            max_delay_time_order = max(delay_order);
            if max_delay_time_order <= max_delay_order
                legal_seq=1;
            end
        end
         % ����Ϳװ������������
        [C1_col_seq,C1_col_record]= GF_buffer_fill_release(C1_assembly,Lane_size,max_lane_num,3);% Ϳװ����
        [C2_col_seq,C2_col_record]= GF_buffer_fill_release(C2_assembly,Lane_size,max_lane_num,3);% Ϳװ����
        % �������ӳ�����������
        [C1_mod_seq,C1_mod_record]= GF_buffer_fill_release(C1_col_seq,Lane_size,max_lane_num,2); % ��������
        [C2_mod_seq,C2_mod_record]= GF_buffer_fill_release(C2_col_seq,Lane_size,max_lane_num,2); % ��������
        % �Ӵ�����
        Children_1 = [Order_seq C1_assembly C1_col_seq C1_mod_seq C1_col_record C1_mod_record];    
        Children_2 = [Order_seq C2_assembly C2_col_seq C2_mod_seq C2_col_record C2_mod_record];
        cross_sets{2*cc1-1,1} = Children_1; % �Ӵ���Ⱥ
        cross_sets{2*cc1,1} = Children_2; % �Ӵ���Ⱥ
    else
        cross_sets{2*cc1-1,1} = Parent_A; % �Ӵ���Ⱥ
        cross_sets{2*cc1,1} = Parent_B; % �Ӵ���Ⱥ
    end
end
seq_result = cross_sets;
end