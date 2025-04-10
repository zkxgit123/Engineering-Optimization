function res_obj = new_objective(individual,Obj)
% 该函数定义了汽车混流生产车间在生产过程中由于颜色和车型切换所产生的碳排放量和需求延误量；
max_col_num = Obj(1,1); % 最大连续喷涂数量
max_mod_num = Obj(1,2);% 最大焊接喷涂数量
tolerance_order_delay = Obj(1,3); % 总装需求容忍延误量
%% 参数设置
OrderSeq = individual(:,1:6);
ass_seq = individual(:,7:12); % 总装序列
col_seq = individual(:,13:18);
mod_seq = individual(:,19:24);
[N,~] = size(OrderSeq);
res_obj = zeros(1,4);
%% 车型、颜色切换次数计算
% 车型切换次数计算
% 参数设置
mod_change_time = 0; % 车型切换次数
mod_add = 1; % 连续焊接数量
for mj = 2 : N
    % 计算夹具更换次数
    if  (mod_seq(mj,2)==mod_seq(mj-1,2))
        mod_add = mod_add + 1; % 连续喷涂数量
    else
        mod_change_time=mod_change_time+1;  % 颜色切换时，需要对涂装喷头进行清洗
        mod_add = 1;
    end
    if mod_add > max_mod_num  % 最大连续焊接数量，
       mod_change_time = mod_change_time + 1;
       mod_add = 1;
    end
end
% 颜色切换次数计算
% 参数设置
col_change_time = 0;   % 颜色切换次数
col_add = 1; % 连续喷涂数量
for ci = 2 : N
    % 计算涂装清洗次数
    if  (col_seq(ci,3)==col_seq(ci-1,3))
        col_add = col_add + 1; % 连续喷涂数量
    else
        col_change_time = col_change_time+1;  % 颜色切换时，需要对涂装喷头进行清洗()
        col_add = 1;
    end
    if col_add > max_col_num  % 最大连续喷涂数量
       col_change_time = col_change_time + 1;
       col_add = 1;
    end
end
%% 目标函数1-碳排放量
E_col_change = 2.9059;
E_mod_change = 7.2612;
Carbon_emission = col_change_time * E_col_change + mod_change_time * E_mod_change ;
res_obj(1,1) = Carbon_emission;
%% 目标函数2-生产成本
Cost_col_change = 374;
Cost_mod_change = 200;
cost_production = col_change_time * Cost_col_change + mod_change_time * Cost_mod_change ;
res_obj(1,2) = cost_production;
%% 目标函数3-物料消耗均衡
w = [0.4 0.3 0.3];
rate_consumption = 0;
n0 = sum(OrderSeq(:,4:6));
ass_option = ass_seq(:,4:6);
for o = 1:3
    for k = 1 : N
        L1 = k*n0(o)/N;
        L2 = sum(ass_option(1:k,o));
        rate_consumption = rate_consumption + w(o) * abs(L1-L2); 
    end
end
res_obj(1,3) = rate_consumption;
%% 目标函数4-订单交付延误
% 参数设置
order_delay = 0;% 总装需求延误量
for oi = 2 : N
    % 计算订单需求延误量
    row_ass = OrderSeq(oi,1);
    row_col = find(ass_seq(:,1)==row_ass);
    if row_col-row_ass > tolerance_order_delay
        order_delay = order_delay + (row_col-row_ass-tolerance_order_delay);  %总装需求延误量
    end
end
res_obj(1,4) = order_delay;
end