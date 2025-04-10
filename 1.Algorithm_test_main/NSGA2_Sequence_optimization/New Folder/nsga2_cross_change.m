function seq_result = nsga2_cross_change(cur_individual,best_individual,Buf)
%% ��������
Lane_size = Buf(1,1);  % ��������
max_lane_num = Buf(1,2); % �����������������
max_delay_order = Buf(1,3); % �����������������
Order_seq = cur_individual(:,1:6); % ��ȡ������װ��������
[N,~] = size(Order_seq); % �������е�����
P1_assembly = cur_individual(:,1:6); 
P2_assembly = best_individual(:,1:6); 
legal_seq = 0;
while legal_seq == 0
    % ������װ������������
    % �����ѡȡ
    L1=zeros(1,2);
    cross_point = rand(1,2);
    L1(1,1) = ceil(min(cross_point)*N);% ����λ��1
    L1(1,2) = ceil(max(cross_point)*N);% ����λ��2
    part1 = P1_assembly(L1:L2);
    part2 = P2_assembly(L1:L2);
    for ii1 = 1:size(part2,1)
        cur_ass_1 = P1_assembly;
        del_ass = cur_ass_1(:,1) == part2(ii1,1);
        cur_ass_1(del_ass,:) = [];
    end
    C1_assembly = [cur_ass_1(1:L1,:) part2 cur_ass_1(L1:end,:)];
    for ii2 = 1:size(part1,1)
        cur_ass_2 = P1_assembly;
        del_ass = cur_ass_2(:,1) == part1(ii2,1);
        cur_ass_2(del_ass,:) = [];
    end
    C2_assembly = [cur_ass_2(1:L1,:) part1 cur_ass_2(L1:end,:)];
    % ��װ���кϷ�
    assemble_order = zeros(N,1);% ���λ���ж�(��װ����-��������)
    delay_order= zeros(N,1);
    for i1=1:N
        assemble_order(i1,1) = find(C1_assembly(i1,1)==Order_seq(:,1));  % Ϳװ����Ķ�������װ�����λ��
        delay_order(i1,1) = i1 - assemble_order(i1,1); % ֵΪ��--Ϳװ����Ķ�������װ�����������
    end
    delay_time_order = max(delay_order);
    if delay_time_order <= max_delay_order
        legal_seq=1;
    end
end
%% ����Ϳװ������������
final_col_seq = Buffer_fill_release(final_ass_seq,Lane_size,max_lane_num,3);% Ϳװ����
%% �������ӳ�����������
final_mod_seq = Buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2); % ��������
%% �������м���
Children_1(:,1:6) = [Order_seq];
Children_1(:,7:12) = [final_ass_seq];
Children_1(:,13:18) = [final_col_seq];
Children_1(:,19:24) = [final_mod_seq];
seq_result = Children_1;
end
