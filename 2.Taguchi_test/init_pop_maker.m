function final_seq = init_pop_maker(OrderSeq,Buf)
% 参数设置
Lane_size = Buf(1,1);  % 车道数量
max_lane_num = Buf(1,2); % 单车道最高容纳数量
max_delay_order = Buf(1,3); % 订单需求最大延误量
%% 构建生产序列
legal_seq = 0;
while legal_seq == 0
    % 构建总装车间生产序列
    [final_ass_seq,maker_ass] = Assembly_seq_maker(OrderSeq);% 总装序列
    % 相对位置判断(总装序列-订单序列)
    assemble_order = OrderSeq(:,1)-final_ass_seq(:,1);  % 涂装车间的订单在总装车间的位置
    delay_time_order = max(assemble_order);
    if delay_time_order <= max_delay_order
        legal_seq=1;
    end
end
%% 构建涂装车间生产序列
[final_col_seq,final_col_record] = GF_buffer_fill_release(final_ass_seq,Lane_size,max_lane_num,3);% 涂装序列
%% 构建焊接车间生产序列
[final_mod_seq,final_mod_record] = GF_buffer_fill_release(final_col_seq,Lane_size,max_lane_num,2);% 焊接序列
%% 生产序列集合
final_seq(:,1:6) = [OrderSeq];
final_seq(:,7:12) = [final_ass_seq];
final_seq(:,13:18) = [final_col_seq];
final_seq(:,19:24) = [final_mod_seq];
final_seq(:,25:26) = [final_col_record];
final_seq(:,27:28) = [final_mod_record];
final_seq(:,29) = [maker_ass];
end
