function [final_seq,final_maker] = nsga2_merge_two_points(Upstream_seq,cross_maker,count_type,type)
[N,~] = size(Upstream_seq); % 订单序列的行数
[Size_type,~] = max(Upstream_seq(:,type)); % 颜色或车型的数量
%% 交叉操作
% 创建子序列
for ii1=1:Size_type
    eval(['subseq_type_',num2str(ii1),'=zeros(0,0)',';'])%生成对应颜色序列subseq_col_ii1==zeros(0,0)
end
% 分配子序列
for ii1 = 1 : N
    cur_type = Upstream_seq(ii1,type); % 提取当前类型
    current_type_subseq=eval(['subseq_type_',num2str(cur_type)]);
    current_type_subseq = [current_type_subseq ; Upstream_seq(ii1,:)]; % 将第ii1行数据复制到current_subseq中
    eval(['subseq_type_',num2str(cur_type),'=current_type_subseq',';']); % 将current_subseq中的数据放至subseq_cur_color中
    current_type_subseq = []; % 清空current_subseq中的数据
end
% 开始分配
final_seq = []; % 返回序列
doing_type = Upstream_seq(1,type);%第一个订单的颜色
ii2 = 1;
while ii2 ~= (N+1)
    p_dis = cross_maker(ii2); 
    if  p_dis==1    % 当p_dis==0时，选择相同颜色
        current_type_subseq = eval(['subseq_type_',num2str(doing_type)]);
        [j_size,~] = size(current_type_subseq);
        if j_size ~= 0  % 颜色序列不为0
            final_seq = [final_seq ; current_type_subseq(1,:)];
            current_type_subseq(1,:)=[];
            eval(['subseq_type_',num2str(doing_type),'=current_type_subseq',';'])
        else
            break; % 当颜色序列为空时，跳出循环
        end
    else           % 当p_dis==0时，选择订单顺序
        do_type_job = 100000;
        loc_type = 0;
        for ii3 = 1 : Size_type 
            judge_type_subseq=eval(['subseq_type_',num2str(ii3)]);
            [judge_type_size,~]=size(judge_type_subseq);
            if judge_type_size == 0 
                continue;
            else
               col_job = find(Upstream_seq(:,1)==judge_type_subseq(1,1));
               if do_type_job > col_job
                  do_type_job = col_job;
                  loc_type = ii3;
               end
            end
        end
        current_type_subseq = eval(['subseq_type_',num2str(loc_type)]);% 返回序号最小的订单
        doing_type = current_type_subseq(1,type);
        final_seq = [final_seq ; current_type_subseq(1,:)];
        current_type_subseq(1,:)=[];
        eval(['subseq_type_',num2str(doing_type),'=current_type_subseq',';'])
    end
    current_type_subseq = [];
    ii2=ii2+1;
end
final_maker = cross_maker(1:ii2-1,:);
% 重新构建生产序列（订单结尾）
while ii2 ~= (N+1)
    % 选取序号最小的订单作为当前序列
    do_type_job=100000;
    loc_type=0;
    for ii3 = 1 : Size_type 
        judge_type_subseq=eval(['subseq_type_',num2str(ii3)]);
        [judge_type_size,~]=size(judge_type_subseq);
        if judge_type_size == 0 
            continue;
        else
           col_job = find(Upstream_seq(:,1)==judge_type_subseq(1,1));
           if do_type_job > col_job
              do_type_job = col_job;
              loc_type = ii3;
           end
        end
    end
    current_type_subseq = eval(['subseq_type_',num2str(loc_type)]);
    [j_size,~]=size(current_type_subseq);
    P_ext = ceil(count_type*rand(1)); % 随机生成一个不大于count_col的数
    if  j_size>=P_ext  % 颜色序列大于R_ext
        final_seq=[final_seq ; current_type_subseq([1:P_ext],:)];%提取R_ext行随机订单序列
        current_type_subseq([1:P_ext],:)=[]; % 删除
    else    % 颜色序列小于R_ext
        final_seq=[final_seq ; current_type_subseq(:,:)];%提取剩余所有行随机订单序列
        current_type_subseq(:,:)=[];%删除
    end
    eval(['subseq_type_',num2str(loc_type),'=current_type_subseq',';'])%返回至相应颜色序列
    current_type_subseq = [];
    end_num_type = size(final_seq,1);
    final_maker(ii2,1) = 0;  % 0--执行订单顺序
    final_maker([ii2+1:end_num_type],1) = 1;  % 1--执行颜色顺序
    ii2=end_num_type+1;
end
