%% 对初始种群开始排序 快速非支配排序
% 使用非支配排序对种群进行排序。该函数返回每个个体对应的排序值和拥挤距离，是一个两列的矩阵。  
% 并将排序值和拥挤距离添加到染色体矩阵中 
function f = non_domination_sort_mod(x, M, V)
    [N,~] = size(x);% N为初始种群的数量
    % M:目标函数的数量  V:决策变量（前面的序列长度）
    clear m
    front = 1;
    F(front).f = [];  %等级为front的支配解集
    individual = [];
    %% 找出“等级最高”的非支配解集
    for i = 1 : N
        individual(i).n = 0;   %n是个体i“被支配”的个体数量
        individual(i).p = [];  %p是被个体i“支配”的个体集合
        for j = 1 : N
            dom_less = 0;
            dom_equal = 0;
            dom_more = 0;
            for k = 1 : M        %判断个体i和个体j的支配关系
                if (x{i,V + k} < x{j,V + k})     % 个体i更优  
                    dom_less = dom_less + 1;
                elseif (x{i,V + k} == x{j,V + k})
                    dom_equal = dom_equal + 1;
                else                             % 个体j更优  
                    dom_more = dom_more + 1;
                end
            end
            if dom_less == 0 && dom_equal ~= M         % 说明i受j支配(个体j更优)
                individual(i).n = individual(i).n + 1; % 相应的n加1
            elseif dom_more == 0 && dom_equal ~= M     % 说明i支配j  (个体i更优)
                individual(i).p = [individual(i).p j]; % 把j加入i的支配合集中
            end
        end
        if individual(i).n == 0  %个体i非支配等级排序最高，属于当前最优解集，相应的染色体中携带代表排序数的信息
            x{i,M + V + 1} = 1;  % 支配等级为1
            F(front).f = [F(front).f i];%等级为1的非支配解集
        end
    end
    %% 为其他个体进行分级
    while ~isempty(F(front).f)
       Q = []; %存放下一个front集合
       for i = 1 : length(F(front).f)        %循环当前支配解集中的个体
           fr_order=F(front).f(i);              %等级为front的订单编号
           fr_set=individual(fr_order).p;       %支配解集的订单编号
           if ~isempty(fr_set)               %个体i有自己所支配的解集
                for j = 1 : length(fr_set)   %循环个体i所支配解集中的个体
                    individual(fr_set(j)).n =individual(fr_set(j)).n - 1;      %这里表示个体j的被支配个数减1
                    if individual(fr_set(j)).n == 0        %如果q是非支配解集，则放入集合Q中
                        x{fr_set(j),M + V + 1} =front + 1;  %个体染色体中加入分级信息
                        Q = [Q fr_set(j)];         %
                    end
                end
           end
       end
       front =  front + 1;  %下一个front集合的等级
       F(front).f = Q;      %将当前支配等级的订单号分配给F
    end
    fr_level = cell2mat(x(:,M + V + 1)); % 初始种群的排序等级
    [~,index_of_fronts] = sort(fr_level);%进行升序排序，index_of_fronts表示排序后的值对应原来的索引
    for i = 1 : length(index_of_fronts)
        sorted_based_on_front(i,:) = x(index_of_fronts(i),:);%sorted_based_on_front为排序后的种群集合
    end
    %% Crowding distance 计算每个个体的拥挤度
    current_index = 0; % 
    for front = 1 : (length(F) - 1)%这里减1是因为F的最后一个元素为空，这样才能跳出循环
        y = {}; % 存放相同等级集合的单元数组
        for i = 1 : length(F(front).f)
            y(i,:) = sorted_based_on_front(current_index + i,:);  % y中存放的是排序等级为front的集合
        end
        sorted_based_on_distance = {};     %存放基于拥挤距离排序的矩阵
        for i = 1 : M
            level_obj = cell2mat(y(:,V + i));%提取当前等级序列的目标函数值
            [~, index_of_obj] = sort(level_obj);%按照目标函数值进行排序
            sorted_based_on_distance = {};
            for j = 1 : length(index_of_obj)
                sorted_based_on_distance(j,:) = y(index_of_obj(j),:);% sorted_based_on_objective存放按照目标函数值排序后的x矩阵
            end
            f_max = sorted_based_on_distance{length(index_of_obj), V + i};   %fmax为目标函数最大值(最后一行) 
            f_min = sorted_based_on_distance{1, V + i};                      %fmin为目标函数最小值（第一行）
            %存放拥挤度
            loc_dis = M + V + 1 + i ;%存放拥挤度的位置((第5列为“目标函数1”的拥挤度；第6列为“目标函数2”的拥挤度))
            y{index_of_obj(length(index_of_obj)),loc_dis}= Inf;   %对排序后的'最后一个个体'的距离设为无穷大
            y{index_of_obj(1),loc_dis} = Inf;                     %对排序后的'第一个个体'的距离设为无穷大
            for j = 2 : length(index_of_obj)-1    %循环集合中除了第一个和最后一个的个体
                next_obj = sorted_based_on_distance{j + 1,V + i};
                previous_obj  = sorted_based_on_distance{j - 1,V + i};
                if (f_max - f_min == 0)
                    y{index_of_obj(j),loc_dis} = Inf;
                else
                    y{index_of_obj(j),loc_dis} =(next_obj - previous_obj)/(f_max - f_min);
                end
             end
        end
        distance = [];
        distance(:,1) = zeros(length(F(front).f),1);
        for i = 1 : M  % 各目标函数对应拥挤度的求和
            dis_obj = cell2mat(y(:,M + V + 1 + i));
            distance(:,1) = distance(:,1) + dis_obj(:,1);
        end
        for j = 1:length(F(front).f)
            y{j,M + V + 2} = distance(j,1);
        end
        y = y(:,1 :(M + V + 2) );%提取种群、目标函数值、排序等级、拥挤距离
        dis_level = cell2mat(y(:,M + V + 2)); % 拥挤度的排序等级
        [~,index_of_dis] = sort(dis_level,1,'DESCEND');%进行升序排序
        sorted_based_on_dis ={};
        for iii1 = 1 : length(index_of_dis)
            sorted_based_on_dis(iii1,:) = y(index_of_dis(iii1),:);%sorted_based_on_front为排序后的种群集合
        end
        previous_index = current_index + 1;
        current_index = current_index + length(F(front).f);  
        init_pop_dom(previous_index:current_index,:) = sorted_based_on_dis; % 将y叠加转移至z
    end
    f = init_pop_dom();%得到的是已经包含等级和拥挤度的种群矩阵 并且已经按等级排序排序
end

