function individual = afsa_individual_maker(OrderSeq)

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

