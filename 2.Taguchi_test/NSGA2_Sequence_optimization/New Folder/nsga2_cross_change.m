function seq_result = nsga2_cross_change(cur_individual,best_individual,Buf)
%% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
max_delay_order = Buf(1,3); % 订单需求最大延误量
Order_seq = cur_individual(:,1:6); % 提取父代总装车间序列
[N,~] = size(Order_seq); % 订单序列的行数
P1_assembly = cur_individual(:,1:6); 
P2_assembly = best_individual(:,1:6); 
legal_seq = 0;
while legal_seq == 0
    % 构建总装车间生产序列
    % 交叉点选取
    L1=zeros(1,2);
    cross_point = rand(1,2);
    L1(1,1) = ceil(min(cross_point)*N);% 交叉位置1
    L1(1,2) = ceil(max(cross_point)*N);% 交叉位置2
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
    % 总装序列合法
    assemble_order = zeros(N,1);% 相对位置判断(总装序列-订单序列)
    delay_order= zeros(N,1);
    for i1=1:N
        assemble_order(i1,1) = find(C1_assembly(i1,1)==Order_seq(:,1));  % 涂装车间的订单在总装车间的位置
        delay_order(i1,1) = i1 - assemble_order(i1,1); % 值为正--涂装车间的订单在总装车间的延误量
    end
    delay_time_order = max(delay_order);
    if delay_time_order <= max_delay_order
        legal_seq=1;
    end
end
%% 构建涂装车间生产序列
final_col_seq = Buffer_fill_release(final_ass_seq,Lane_size,max_lane_num,3);% 涂装序列
%% 构建焊接车间生产序列
final_mod_seq = Buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2); % 焊接序列
%% 生产序列集合
Children_1(:,1:6) = [Order_seq];
Children_1(:,7:12) = [final_ass_seq];
Children_1(:,13:18) = [final_col_seq];
Children_1(:,19:24) = [final_mod_seq];
seq_result = Children_1;
end
