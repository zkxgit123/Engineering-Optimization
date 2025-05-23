function [FPA_final_seq] = pollination(init_pop_dom,P_poll,Buf)
[N,~] = size(init_pop_dom); % 种群数量
best_individual = init_pop_dom{1,:};     % 最优解
normal_set = init_pop_dom(2:N,:); % 其他解集
random_set = init_pop_dom(:,:);%随机解集
z1 = 1 ;% 授粉种群
seq_result = cell(N-1,1);
%% 花授粉种群优化
for init = 2:N
    cur_individual = normal_set{init-1,:}; % 依次抽取一个非最优解
    %% 花授粉类型切换
    p_pollination=rand(1);
    % 自花授粉（概率为20%）
    if  p_pollination>P_poll
        % 随机抽取两个不同的解作为随机解
        r1 = ceil(N*rand(1));
        r2 = ceil(N*rand(1));
        while r1 == r2 || r1 == init || r2 == init
            r1 = ceil(N*rand(1));
            r2 = ceil(N*rand(1));
        end
        middle_1= random_set{r1,1};   % 随机解1的订单序列
        middle_2 = random_set{r2,1};  % 随机解2的订单序列
        seq_output = self_pollination2(cur_individual,middle_1,middle_2,Buf);
        % 异花授粉
    else
        seq_output = cross_pollination2(cur_individual,best_individual,Buf);
    end
    seq_result{z1,1}=seq_output;
    z1 = z1 + 1;
end
FPA_final_seq=seq_result;
end
