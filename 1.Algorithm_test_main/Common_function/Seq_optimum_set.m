function res = Seq_optimum_set(seq_iteration,F,class)
% 提取最优解集
% F代表等级所在位置
% class代表所要保存的等级为class的种群
N_front=1;
for k=1:size(seq_iteration,1)
    if seq_iteration{k,F}==class
        N_front = N_front+1;
    end
end
res = seq_iteration(1:N_front-1,:);
end
