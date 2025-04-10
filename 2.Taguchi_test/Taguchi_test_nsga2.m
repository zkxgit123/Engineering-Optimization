clc;
clear;
%% 添加路径
addpath('Common_function');
addpath('Buffer_rule_GF_optimization');
addpath('NSGA2_Sequence_optimization');
%% 样本选取定义
group_size = 50;       % 种群数量
Num_ite = 50; % 迭代次数
Ref_point = [1500,120000,1000,5000];  % Ref_point为参考点800
Operat_Times = 1;
%% 车身订单序列
OrderSeq = readmatrix('neworder300.xlsx');%随机初始化订单序列
%% 初始参数设置
V = 1; % 零件序号
M = 4; % 目标函数数量
% 目标函数参数设定
Obj(1,1) = 20;% 最大连续喷涂数量
Obj(1,2) = 40;% 最大焊接喷涂数量
Obj(1,3) = 10;% 总装需求容忍延误量
% 缓冲区设定参数
Buf(1,1)= 7 ; % 车道数量10
Buf(1,2) = 8; % 单车道最高容纳数量10
Buf(1,3) = 40; % 订单需求最大延误量
% save('init_pop.mat','init_pop');
% load('init_pop_2.mat')
%% 变量设置
TA=[1	1	1	1;2	1	2	3;3	1	3	2;4	2	1	3;5	2	2	2;6	2	3	1;
    7	3	1	2;8	3	2	1;9	3	3	3];
row_test = size(TA,1);
P_cross = [0.5 0.7 0.9];
P_muta = [0.2 0.4 0.6];
%% 算法迭代运算
final_seq = cell(Operat_Times,row_test); % 返回的每次运算的最优解集（最后一组解集）
for i1=1:Operat_Times
    fprintf('第%d次运算\n', i1);
    %% 初始种群构建  
    init_pop = cell(group_size,5);% 新建初始种群
    for ii2=1:group_size
        individual = init_pop_maker(OrderSeq,Buf); % 初始种群
        res_obj = new_objective(individual,Obj); % 目标函数赋值
        init_pop{ii2,1}= individual;
        init_pop{ii2,2} = res_obj(1,1); % 碳排放量
        init_pop{ii2,3} = res_obj(1,2); % 生产成本
        init_pop{ii2,4} = res_obj(1,3); % 物料均衡率
        init_pop{ii2,5} = res_obj(1,4); % 总拖期延误
    end
    %% 算法迭代
    for j1=1:row_test
        fprintf('第%d组算法实验,', j1);
        p_cross = P_cross(1,TA(j1,2));
        p_muta = P_muta(1,TA(j1,3));
        ans_set = Algorithm_NSGA2(j1,init_pop,M,V,Num_ite,group_size,p_cross,p_muta,Ref_point,Buf,Obj);   % NSGA-II算法
        final_seq{i1,j1} = ans_set(:,:); % 算法Alg_num运算kk1次之后存放的位置
    end
end
Taguchi_nsga2 = zeros(row_test,Operat_Times);
for i1=1:Operat_Times
    for j1=1:row_test
        ans_set =  final_seq{i1,j1};
        Taguchi_nsga2(j1,i1) = cell2mat(ans_set(Num_ite,2));
    end
end
%% 算法迭代效果分析
save('Taguchi_nsga2.mat','Taguchi_nsga2');
% Taguchi_seq_6 = final_seq;
% save('Taguchi_seq_6.mat','Taguchi_seq_6');
