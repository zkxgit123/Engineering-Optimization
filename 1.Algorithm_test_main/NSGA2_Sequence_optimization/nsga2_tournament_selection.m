function final_seq = nsga2_tournament_selection(init_pop_dom, pop_of_seq, tour_size)
% ***********************选择策略*******************************
% **************************************************************
% pool_size:出来的种群的个体的数量
% 提取等级为
% V=1;
% M=2;
% loc_front = V+M+1;  % 排序等级所在位置
% final_seq = cell(pop_of_seq,V+M);
% final_seq = Seq_optimum_set(init_pop_dom,loc_front,1);  % 搜索等级为1的解保存至Optimum_seq_fpa中
% num_front_1 = size(final_seq,1);
[pop, variables] = size(init_pop_dom); % 获得种群的个体数量和决策变量数量
rank = variables - 1; % 个体向量中排序值所在位置(倒数第二个)
distance = variables; % 个体向量中拥挤度所在位置（倒数第一个）
%竞标赛选择法，每次随机选择两个个体，优先选择排序等级高的个体，如果排序等级一样，优选选择拥挤度大的个体
for i = 1 : pop_of_seq % 一次循环输出两个结果
    for j = 1 : tour_size  % 一次挑选tour_size个进行分选
        candidate(j) = round(pop*rand(1)); % 随机选择参赛个体
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            while ~isempty(find(candidate(1 : j - 1) == candidate(j), 1))%防止两个参赛个体是同一个
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    c_obj_rank =[]; %cell(2,1);
    c_obj_distance =[];% cell(2,1);
    for j = 1 : tour_size % 记录每个参赛者的排序等级、拥挤度
        c_obj_rank(j,1) = cell2mat(init_pop_dom(candidate(j),rank));
        c_obj_distance(j,1) = cell2mat(init_pop_dom(candidate(j),distance));
    end
    min_candidate = find(c_obj_rank == min(c_obj_rank));%选择排序等级较小的参赛者，find返回该参赛者的索引
    if length(min_candidate) ~= 1    %如果两个参赛者的排序等级相等 则继续比较拥挤度 优先选择拥挤度大的个体
        max_candidate = find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1  % 即拥挤度相等的情况，即出现了多个拥挤度相等的个体
            max_candidate = max_candidate(unidrnd(2));
        end
        final_seq(i,:) = init_pop_dom(candidate(min_candidate(max_candidate)),:);
    else
        final_seq(i,:) = init_pop_dom(candidate(min_candidate(1)),:);
    end
end
