function [FPA_final_seq] = FPA_pollination(init_pop_dom,P_poll,Buf)
[N,~] = size(init_pop_dom); % ��Ⱥ����
best_individual = init_pop_dom{1,:};     % ���Ž�
normal_set = init_pop_dom(2:N,:); % �����⼯
random_set = init_pop_dom(:,:);%����⼯
z1 = 1 ;% �ڷ���Ⱥ
seq_result = cell(N-1,1);
%% ���ڷ���Ⱥ�Ż�
for init = 2:N
    cur_individual = normal_set{init-1,:}; % ���γ�ȡһ�������Ž�
    %% ���ڷ������л�
    p_pollination=rand(1);
    if  p_pollination>P_poll  % �Ի��ڷۣ�����Ϊ20%��
        % �����ȡ������ͬ�Ľ���Ϊ�����
        r1 = ceil(N*rand(1));
        while  r1 == init 
            r1 = ceil(N*rand(1));
        end
        middle_1= random_set{r1,1};   % �����1�Ķ�������
        seq_output = FPA_cross_operator(cur_individual,middle_1,Buf);
    else  % �컨�ڷ� 
        seq_output = FPA_cross_operator(cur_individual,best_individual,Buf);
    end
    seq_result{z1,1}=seq_output;
    z1 = z1 + 1;
end
FPA_final_seq=seq_result;
end
