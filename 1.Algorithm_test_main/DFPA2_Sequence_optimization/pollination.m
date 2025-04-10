function [FPA_final_seq] = pollination(init_pop_dom,P_poll,Buf)
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
    % �Ի��ڷۣ�����Ϊ20%��
    if  p_pollination>P_poll
        % �����ȡ������ͬ�Ľ���Ϊ�����
        r1 = ceil(N*rand(1));
        r2 = ceil(N*rand(1));
        while r1 == r2 || r1 == init || r2 == init
            r1 = ceil(N*rand(1));
            r2 = ceil(N*rand(1));
        end
        middle_1= random_set{r1,1};   % �����1�Ķ�������
        middle_2 = random_set{r2,1};  % �����2�Ķ�������
        seq_output = self_pollination2(cur_individual,middle_1,middle_2,Buf);
        % �컨�ڷ�
    else
        seq_output = cross_pollination2(cur_individual,best_individual,Buf);
    end
    seq_result{z1,1}=seq_output;
    z1 = z1 + 1;
end
FPA_final_seq=seq_result;
end
