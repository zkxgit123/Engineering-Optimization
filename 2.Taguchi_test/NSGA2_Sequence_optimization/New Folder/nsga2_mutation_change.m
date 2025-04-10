function [final_seq] =nsga2_mutation_change(cur_individual,Buf)
%% 参数设置
Lane_col_size = Buf(1,1); % PBS车道数量 
Lane_mod_size = Buf(1,2); % WBS车道数量
max_lane_num = Buf(1,3);  % 单车道最高容纳数量
max_delay =Buf(1,4); % 最大延误量
%% 变异操作
%将变异重组后的序列索引改变
[length,width] = size(cur_individual);
final_seq = zeros(length,width);
seq_maker_col = cur_individual(:,10);
seq_maker_mod = cur_individual(:,11);
%% 总装车间
Order_seq = cur_individual(:,1:3); % 提取父代总装车间序列
%% 涂装序列变异
count_mark_col = 1;
while count_mark_col <= 20 % 为了防止陷入死循环，失败100次则放弃优化
    temp_seq_col = nsga2_mutation_maker_points(seq_maker_col);
    [Painting_seq,Painting_maker] = nsga2_merge_two_points(Order_seq,temp_seq_col,count_col,3);
    legal_col = nsga2_legal_judge(Order_seq,Painting_seq,max_delay,Lane_col_size,max_lane_num);
    if legal_col==1   % PBS缓冲区合法
        % 焊装车间交叉序列
        count_mark_mod =1;
        while count_mark_mod<=20 % 为了防止陷入死循环，失败100次则放弃优化
            temp_seq_mod = nsga2_mutation_maker_points(seq_maker_mod);
            [Welding_seq , Welding_maker] = nsga2_merge_two_points(Painting_seq,temp_seq_mod,count_mod,2);
            legal_mod = nsga2_legal_judge(Painting_seq,Welding_seq,max_delay,Lane_mod_size,max_lane_num);
            if legal_mod==1   % WBS缓冲区合法
                break;
            else    % WBS缓冲区不合法
                Welding_seq = cur_individual(:,7:9);
                Welding_maker = cur_individual(:,11); % 父代1的选择序列标记
                count_mark_mod = count_mark_mod+1; % 记录失败次数
            end
        end
        break;  % 跳出第一个while循环
    else   % PBS缓冲区排产序列不合法
        Painting_seq = cur_individual(:,4:6);
        Painting_maker = cur_individual(:,10); % 父代1的选择序列标记
        count_mark_col = count_mark_col+1; % 记录失败次数
    end
end
%%  输出变异结果
final_seq(:,1:3) =  cur_individual(:,1:3);
final_seq(:,4:6) =  Painting_seq(:,1:3);
final_seq(:,7:9) =  Welding_seq(:,1:3);
final_seq(:,10)  =  Painting_maker;
final_seq(:,11)  =  Welding_maker;
end

