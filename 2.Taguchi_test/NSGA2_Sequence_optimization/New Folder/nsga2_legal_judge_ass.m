function  legal_judge = nsga2_legal_judge_ass(Down_seq,Up_seq,max_delay)
% Down_seq 为下游序列-Order_seq
% Up_seq 为上游序列-Assembly_seq
[N,~] = size(Down_seq); % 订单长度
assemble_order = zeros(N,1);
delay_time= zeros(N,1);
for i1=1:N
    assemble_order(i1,1) = find(Up_seq(i1,1)==Down_seq(:,1));  % 涂装车间的订单在总装车间的位置
    delay_time(i1,1) = i1 - assemble_order(i1,1); % 值为正--涂装车间的订单在总装车间的延误量
end
delay_max_time = max(delay_time); 
% 延误次数要求判断
if  delay_max_time > max_delay  % 延误次数不满足要求
    legal_judge = 0;
else   % 满足要求，进一步判断合法性
    legal_judge=1;
end
