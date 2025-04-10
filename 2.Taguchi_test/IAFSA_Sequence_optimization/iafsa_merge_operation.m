function [final_seq] = iafsa_merge_operation(Order_seq,cross_maker)
[N,~] = size(Order_seq); % 订单序列的行数
% 创建子序列（颜色序列）--涂装车间
Optype = [0 0 0;0 0 1;0 1 0;0 1 1; 1 0 0; 1 0 1;1 1 0;1 1 1];
op_size = size(Optype,1);
for o1=1:op_size
    eval(['subseq_ass_',num2str(o1),'=zeros(0,0)',';'])%生成对应颜色序列subseq_col_ii1==zeros(0,0)
end
% 分配子序列
for a1=1:N
    opcom = Order_seq(a1,4:6);
    cur_option = opcom(1)*2^2+opcom(2)*2^1+opcom(3)*2^0+1;
    current_ass_subseq=eval(['subseq_ass_',num2str(cur_option)]);
    current_ass_subseq = [current_ass_subseq ; Order_seq(a1,:)];%将第ii1行数据复制到current_subseq中
    eval(['subseq_ass_',num2str(cur_option),'=current_ass_subseq',';']);%将current_subseq中的数据放至subseq_cur_color中
    current_ass_subseq = [];%清空current_subseq中的数据
end
%% 构建初始种群序列
% 通过设置一个随机数p，确定选择相同颜色数量，然后重新检索各颜色序列的订单最小值
final_ass_seq = zeros(0,0); % 返回序列
for ii1 = 1:N
    judge_make = cross_maker(ii1,1);
    if  judge_make==1     % 1--执行总装最优顺序 % 抽取物料消耗率最均衡的车辆进行排序
        f3 = zeros(8,1);
        cur_option = final_ass_seq(:,4:6);
        for a1 = 1 : op_size
            j_ass_subseq = eval(['subseq_ass_',num2str(a1)]);
            [judge_opt_size,~]=size(j_ass_subseq);
            if judge_opt_size == 0 
                f3(a1,1)= inf;
            else
                next_option = Optype(a1,:);
                ass_op = [cur_option;next_option];
                n0 = sum(Order_seq(:,4:6));
                w = [0.4 0.3 0.3];
                k = size(ass_op,1);
                for o = 1:3
                    L1 = k*n0(o)/N;
                    L2 = sum(ass_op(:,o));
                    f3(a1,1) = f3(a1,1) + w(o) * abs(L1-L2); 
                end
            end
        end
        % 订单选取
        opti_index = find(f3==min(f3));
        [num_op,~] = size(opti_index);
        if num_op ==1  % 当目标函数最小的订单只有一个时
            loc_op = opti_index(1);
        else           % 选取目标函数最小 & 订单编号最小的订单（延误量最小）
            do_ass_job=100000;
            for a11= 1:num_op
                judge_ass_subseq = eval(['subseq_ass_',num2str(opti_index(a11))]);
                [judge_ass_size,~]=size(judge_ass_subseq);
                if judge_ass_size == 0 
                    continue;
                else
                    if do_ass_job > judge_ass_subseq(1,1)
                       do_ass_job = judge_ass_subseq(1,1);
                       loc_op=opti_index(a11);
                    end
                end
            end
        end
    else                 % 选取订单编号最小的订单
        j_ass_job=100000;
        for aj1= 1:op_size
            judge_ass_subseq = eval(['subseq_ass_',num2str(aj1)]);
            [judge_ass_size,~]=size(judge_ass_subseq);
            if judge_ass_size == 0 
                continue;
            else
                if j_ass_job > judge_ass_subseq(1,1)
                   j_ass_job = judge_ass_subseq(1,1);
                   loc_op = aj1;
                end
            end
        end
    end
    current_ass_subseq = eval(['subseq_ass_',num2str(loc_op)]);
    final_ass_seq(ii1,:) = current_ass_subseq(1,:);
    current_ass_subseq(1,:)=[];%删除
    eval(['subseq_ass_',num2str(loc_op),'=current_ass_subseq',';'])%返回至相应颜色序列
    current_ass_subseq = [];
end
final_seq = final_ass_seq;
end
