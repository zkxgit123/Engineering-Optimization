function [non_dominate_follow]=iafsa_follow_behavior(fr,loc_swam,delta,visual_range,n_try,Buf,Obj)
V=1; % 零件数
M=4; % 目标函数,P_cross_swam,P_muta_swam
group_size=size(loc_swam,1); % 返回行数
%% 邻域范围的人工鱼索引
a=1:1:group_size;
if fr>=1+visual_range/2 && fr<=group_size-visual_range/2
    visual_index=a(fr-visual_range/2:fr+visual_range/2);
elseif fr<1+visual_range/2
    visual_index=[a(end-visual_range/2+fr:end),a(1:fr+visual_range/2)];
else 
    visual_index=[a(fr-visual_range/2:end),a(1:fr-end+visual_range/2)];
end
%% 人工鱼标记
swam_current=loc_swam(fr,:); 
visual_swam=loc_swam(visual_index,:);
visual_swam(visual_range/2+1,:) = [];
%% 拥挤度判断
sup_num=0;
for ii1=1:length(visual_swam)
    ss = iafsa_dominant_judgement(swam_current,visual_swam(ii1,:),M,V);
    if  ss ~= 1
        sup_num=sup_num+1;    % 求解比swam_current优的个数
    end
end
%% 人工鱼行为
Q_follow = cell(1,V+M);
if  sup_num/visual_range > delta  % 太过于拥挤时，进入觅食行为
    Q_follow{1,1} = iafsa_predator(swam_current,visual_swam,visual_range,n_try,Buf);
else  % 不过于拥挤时
    % 确定最优个体Xb
    visual_swam = non_domination_sort_mod(visual_swam, M, V);
    best_swam = visual_swam(1,:);
    seq_output = iafsa_cross_pollination(swam_current{1,1},best_swam{1,1},Buf);
    Q_follow{1,1} = seq_output;
end
%% 判定支配关系
Q_follow_object = new_objective(Q_follow{1,1},Obj);
Q_follow{1,2} = Q_follow_object(1,1);% 碳排放量
Q_follow{1,3} = Q_follow_object(1,2);% 生产成本
Q_follow{1,4} = Q_follow_object(1,3);% 物料均衡率
Q_follow{1,5} = Q_follow_object(1,4);% 总拖期延误
judge_operator =cell(2,V+M);
judge_operator(1,:) = swam_current(1,1:V+M);
judge_operator(2,:) = Q_follow(1,1:V+M);
non_dominate_follow = iafsa_non_domination_solution(judge_operator, M, V);
end