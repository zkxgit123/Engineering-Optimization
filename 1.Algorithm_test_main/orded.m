%客户需求订单序列随机生成
% function res_seq = orded(N)
clc;
clear;
N = 200;
size_of_order = N;                  % 订单总量
%% 车型、颜色分配1
% Mod_distribution = [0.25 0.25 0.25 0.25]; % 车型分配
% Col_distribution = [0.38,0.19,0.15,0.09,0.07,0.05,0.04,0.03]; 
% MC = {[1 2 3 4 6];[1 2 4 5 ];[1 2 3 6 8];[1 2 3 7]};
%% 车型、颜色分配2
Mod_distribution = [0.25 0.25 0.25 0.25]; % 车型分配
Col_distribution = [0.41,0.23,0.20,0.16]; % 颜色分配1
MC = {[1 2 3 4];[1 2 3 4];[1 2 3 4];[1 2 3 4]};
% MC = {[1 2 3 4 5 6 7 8];[1 2 3 4 5 6 7 8];[1 2 3 4 5 6 7 8];[1 2 3 4 5 6 7 8]};
%% 随机初始化订单序列
mm = size(MC,1);
seq_of_order = zeros(size_of_order,6);% 创建订单序列,三列分别为：订单编号，车型，颜色代码，配置1，配置2，配置3
seq_of_order(1,:) = [1 1 1 1 1 1];
i = 2;
while i<= size_of_order
    seq_of_order(i,1)=i;%序号
    cur_mod = ceil(mm*rand(1)); % 随机产生1种型号
    num_mod = sum(seq_of_order(:,2) == cur_mod);
    if  num_mod <= size_of_order*Mod_distribution(cur_mod)
        col_group = MC{cur_mod,1};
        cc= size(col_group,2);
        cur_col = col_group(1,ceil(cc*rand(1))); % 随机产生1种颜色
        num_col =  sum(seq_of_order(:,3) == cur_col);
        if  num_col <= size_of_order*Col_distribution(cur_col)
            seq_of_order(i,2)= cur_mod ; 
            seq_of_order(i,3)= cur_col ;
            seq_of_order(i,4)= ceil(rand(1)-0.5); % 配置1
            seq_of_order(i,5)= ceil(rand(1)-0.5); % 配置2
            seq_of_order(i,6)= ceil(rand(1)-0.5); % 配置3
            i=i+1;
        end
    end
end
res_seq = seq_of_order;
xlswrite('neworder200.xlsx',res_seq);
 
