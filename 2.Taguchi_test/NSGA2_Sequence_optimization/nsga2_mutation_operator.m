function [after_mutation] = nsga2_mutation_operator(after_cross_over,P_muta,Buf,Obj)
%% ��������
Lane_size = Buf(1,1);  % ��������
max_lane_num = Buf(1,2); % �����������������
max_delay_order = Buf(1,3); % �����������������
[Group_size,~] = size(after_cross_over);% ��Ⱥ����
after_mutation=cell(Group_size,5); % ��������Ľ�
for ii2=1:Group_size
    p_mutation=rand(1);% ����������
    if   p_mutation <= P_muta   % ����С��20%ʱ���������
        temp_individual = after_cross_over{ii2,1};
        Order_seq = temp_individual(:,1:6); 
        P1_assembly = temp_individual(:,7:12); 
        [N,~] = size(P1_assembly);
        legal_seq = 0;
        while legal_seq == 0
            % ������װ������������
            L = sort(rand(1,2));%         n_points = 2;
            L_c = ceil(L*N); % ����λ��
            C1_assembly = P1_assembly(:,:);
            C1_assembly(L_c(1,1),:) = P1_assembly(L_c(1,2),:);
            C1_assembly(L_c(1,2),:) = P1_assembly(L_c(1,1),:);
            % ��װ���кϷ�
            delay_order =  Order_seq(:,1) - C1_assembly(:,1);
            max_delay_time_order = max(delay_order);
            if max_delay_time_order <= max_delay_order
                legal_seq=1;
            end
        end
        % ����Ϳװ������������
        [final_col_seq,final_col_record]= GF_buffer_fill_release(C1_assembly,Lane_size,max_lane_num,3);% Ϳװ����
        % �������ӳ�����������
        [final_mod_seq,final_mod_record]= GF_buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2); % ��������
        % �Ӵ�����
        Children_1 = [Order_seq C1_assembly final_col_seq final_mod_seq final_col_record final_mod_record];
        after_mutation{ii2,1}=Children_1;
    else
        after_mutation{ii2,1}=after_cross_over{ii2,1};  % �����б���
    end
    % Ŀ�꺯����ֵ
    res_obj = new_objective(after_mutation{ii2,1},Obj); % Ŀ�꺯����ֵ
    after_mutation{ii2,2} = res_obj(1,1); % ̼�ŷ���
    after_mutation{ii2,3} = res_obj(1,2); % �����ɱ�
    after_mutation{ii2,4} = res_obj(1,3); % ���Ͼ�����
    after_mutation{ii2,5} = res_obj(1,4); % ����������
end

end
