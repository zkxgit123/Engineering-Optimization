function  legal_judge = nsga2_legal_judge(Down_seq,Up_seq,max_delay,Lane_size,max_lane_num)
% Down_seq 为下游序列
% Up_seq 为上游序列
[N,~] = size(Down_seq); % 订单长度
paint_assemble = zeros(N,1);
delay_time= zeros(N,1);
for i1=1:N
    paint_assemble(i1,1) = find(Up_seq(i1,1)==Down_seq(:,1));  % 涂装车间的订单在总装车间的位置
    delay_time(i1,1) = i1 - paint_assemble(i1,1); % 值为正--涂装车间的订单在总装车间的延误量
end
delay_max_time = max(delay_time); 
% 延误次数要求判断
if  delay_max_time > max_delay  % 延误次数不满足要求
    legal_judge=0;
else   % 满足要求，进一步判断合法性
    [legal_col_in,legal_col_out]= buffer_constrian_pbs(Up_seq,paint_assemble,Lane_size,max_lane_num);
    if legal_col_in==1 && legal_col_out==1   % 序列合法
        legal_judge=1;
    else
        legal_judge=0;
    end
end
