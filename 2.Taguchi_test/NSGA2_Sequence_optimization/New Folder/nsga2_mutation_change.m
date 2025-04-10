function [final_seq] =nsga2_mutation_change(cur_individual,Buf)
%% ��������
Lane_col_size = Buf(1,1); % PBS�������� 
Lane_mod_size = Buf(1,2); % WBS��������
max_lane_num = Buf(1,3);  % �����������������
max_delay =Buf(1,4); % ���������
%% �������
%���������������������ı�
[length,width] = size(cur_individual);
final_seq = zeros(length,width);
seq_maker_col = cur_individual(:,10);
seq_maker_mod = cur_individual(:,11);
%% ��װ����
Order_seq = cur_individual(:,1:3); % ��ȡ������װ��������
%% Ϳװ���б���
count_mark_col = 1;
while count_mark_col <= 20 % Ϊ�˷�ֹ������ѭ����ʧ��100��������Ż�
    temp_seq_col = nsga2_mutation_maker_points(seq_maker_col);
    [Painting_seq,Painting_maker] = nsga2_merge_two_points(Order_seq,temp_seq_col,count_col,3);
    legal_col = nsga2_legal_judge(Order_seq,Painting_seq,max_delay,Lane_col_size,max_lane_num);
    if legal_col==1   % PBS�������Ϸ�
        % ��װ���佻������
        count_mark_mod =1;
        while count_mark_mod<=20 % Ϊ�˷�ֹ������ѭ����ʧ��100��������Ż�
            temp_seq_mod = nsga2_mutation_maker_points(seq_maker_mod);
            [Welding_seq , Welding_maker] = nsga2_merge_two_points(Painting_seq,temp_seq_mod,count_mod,2);
            legal_mod = nsga2_legal_judge(Painting_seq,Welding_seq,max_delay,Lane_mod_size,max_lane_num);
            if legal_mod==1   % WBS�������Ϸ�
                break;
            else    % WBS���������Ϸ�
                Welding_seq = cur_individual(:,7:9);
                Welding_maker = cur_individual(:,11); % ����1��ѡ�����б��
                count_mark_mod = count_mark_mod+1; % ��¼ʧ�ܴ���
            end
        end
        break;  % ������һ��whileѭ��
    else   % PBS�������Ų����в��Ϸ�
        Painting_seq = cur_individual(:,4:6);
        Painting_maker = cur_individual(:,10); % ����1��ѡ�����б��
        count_mark_col = count_mark_col+1; % ��¼ʧ�ܴ���
    end
end
%%  ���������
final_seq(:,1:3) =  cur_individual(:,1:3);
final_seq(:,4:6) =  Painting_seq(:,1:3);
final_seq(:,7:9) =  Welding_seq(:,1:3);
final_seq(:,10)  =  Painting_maker;
final_seq(:,11)  =  Welding_maker;
end

