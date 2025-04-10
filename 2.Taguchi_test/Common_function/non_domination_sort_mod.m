%% �Գ�ʼ��Ⱥ��ʼ���� ���ٷ�֧������
% ʹ�÷�֧���������Ⱥ�������򡣸ú�������ÿ�������Ӧ������ֵ��ӵ�����룬��һ�����еľ���  
% ��������ֵ��ӵ��������ӵ�Ⱦɫ������� 
function f = non_domination_sort_mod(x, M, V)
    [N,~] = size(x);% NΪ��ʼ��Ⱥ������
    % M:Ŀ�꺯��������  V:���߱�����ǰ������г��ȣ�
    clear m
    front = 1;
    F(front).f = [];  %�ȼ�Ϊfront��֧��⼯
    individual = [];
    %% �ҳ����ȼ���ߡ��ķ�֧��⼯
    for i = 1 : N
        individual(i).n = 0;   %n�Ǹ���i����֧�䡱�ĸ�������
        individual(i).p = [];  %p�Ǳ�����i��֧�䡱�ĸ��弯��
        for j = 1 : N
            dom_less = 0;
            dom_equal = 0;
            dom_more = 0;
            for k = 1 : M        %�жϸ���i�͸���j��֧���ϵ
                if (x{i,V + k} < x{j,V + k})     % ����i����  
                    dom_less = dom_less + 1;
                elseif (x{i,V + k} == x{j,V + k})
                    dom_equal = dom_equal + 1;
                else                             % ����j����  
                    dom_more = dom_more + 1;
                end
            end
            if dom_less == 0 && dom_equal ~= M         % ˵��i��j֧��(����j����)
                individual(i).n = individual(i).n + 1; % ��Ӧ��n��1
            elseif dom_more == 0 && dom_equal ~= M     % ˵��i֧��j  (����i����)
                individual(i).p = [individual(i).p j]; % ��j����i��֧��ϼ���
            end
        end
        if individual(i).n == 0  %����i��֧��ȼ�������ߣ����ڵ�ǰ���Ž⼯����Ӧ��Ⱦɫ����Я����������������Ϣ
            x{i,M + V + 1} = 1;  % ֧��ȼ�Ϊ1
            F(front).f = [F(front).f i];%�ȼ�Ϊ1�ķ�֧��⼯
        end
    end
    %% Ϊ����������зּ�
    while ~isempty(F(front).f)
       Q = []; %�����һ��front����
       for i = 1 : length(F(front).f)        %ѭ����ǰ֧��⼯�еĸ���
           fr_order=F(front).f(i);              %�ȼ�Ϊfront�Ķ������
           fr_set=individual(fr_order).p;       %֧��⼯�Ķ������
           if ~isempty(fr_set)               %����i���Լ���֧��Ľ⼯
                for j = 1 : length(fr_set)   %ѭ������i��֧��⼯�еĸ���
                    individual(fr_set(j)).n =individual(fr_set(j)).n - 1;      %�����ʾ����j�ı�֧�������1
                    if individual(fr_set(j)).n == 0        %���q�Ƿ�֧��⼯������뼯��Q��
                        x{fr_set(j),M + V + 1} =front + 1;  %����Ⱦɫ���м���ּ���Ϣ
                        Q = [Q fr_set(j)];         %
                    end
                end
           end
       end
       front =  front + 1;  %��һ��front���ϵĵȼ�
       F(front).f = Q;      %����ǰ֧��ȼ��Ķ����ŷ����F
    end
    fr_level = cell2mat(x(:,M + V + 1)); % ��ʼ��Ⱥ������ȼ�
    [~,index_of_fronts] = sort(fr_level);%������������index_of_fronts��ʾ������ֵ��Ӧԭ��������
    for i = 1 : length(index_of_fronts)
        sorted_based_on_front(i,:) = x(index_of_fronts(i),:);%sorted_based_on_frontΪ��������Ⱥ����
    end
    %% Crowding distance ����ÿ�������ӵ����
    current_index = 0; % 
    for front = 1 : (length(F) - 1)%�����1����ΪF�����һ��Ԫ��Ϊ�գ�������������ѭ��
        y = {}; % �����ͬ�ȼ����ϵĵ�Ԫ����
        for i = 1 : length(F(front).f)
            y(i,:) = sorted_based_on_front(current_index + i,:);  % y�д�ŵ�������ȼ�Ϊfront�ļ���
        end
        sorted_based_on_distance = {};     %��Ż���ӵ����������ľ���
        for i = 1 : M
            level_obj = cell2mat(y(:,V + i));%��ȡ��ǰ�ȼ����е�Ŀ�꺯��ֵ
            [~, index_of_obj] = sort(level_obj);%����Ŀ�꺯��ֵ��������
            sorted_based_on_distance = {};
            for j = 1 : length(index_of_obj)
                sorted_based_on_distance(j,:) = y(index_of_obj(j),:);% sorted_based_on_objective��Ű���Ŀ�꺯��ֵ������x����
            end
            f_max = sorted_based_on_distance{length(index_of_obj), V + i};   %fmaxΪĿ�꺯�����ֵ(���һ��) 
            f_min = sorted_based_on_distance{1, V + i};                      %fminΪĿ�꺯����Сֵ����һ�У�
            %���ӵ����
            loc_dis = M + V + 1 + i ;%���ӵ���ȵ�λ��((��5��Ϊ��Ŀ�꺯��1����ӵ���ȣ���6��Ϊ��Ŀ�꺯��2����ӵ����))
            y{index_of_obj(length(index_of_obj)),loc_dis}= Inf;   %��������'���һ������'�ľ�����Ϊ�����
            y{index_of_obj(1),loc_dis} = Inf;                     %��������'��һ������'�ľ�����Ϊ�����
            for j = 2 : length(index_of_obj)-1    %ѭ�������г��˵�һ�������һ���ĸ���
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
        for i = 1 : M  % ��Ŀ�꺯����Ӧӵ���ȵ����
            dis_obj = cell2mat(y(:,M + V + 1 + i));
            distance(:,1) = distance(:,1) + dis_obj(:,1);
        end
        for j = 1:length(F(front).f)
            y{j,M + V + 2} = distance(j,1);
        end
        y = y(:,1 :(M + V + 2) );%��ȡ��Ⱥ��Ŀ�꺯��ֵ������ȼ���ӵ������
        dis_level = cell2mat(y(:,M + V + 2)); % ӵ���ȵ�����ȼ�
        [~,index_of_dis] = sort(dis_level,1,'DESCEND');%������������
        sorted_based_on_dis ={};
        for iii1 = 1 : length(index_of_dis)
            sorted_based_on_dis(iii1,:) = y(index_of_dis(iii1),:);%sorted_based_on_frontΪ��������Ⱥ����
        end
        previous_index = current_index + 1;
        current_index = current_index + length(F(front).f);  
        init_pop_dom(previous_index:current_index,:) = sorted_based_on_dis; % ��y����ת����z
    end
    f = init_pop_dom();%�õ������Ѿ������ȼ���ӵ���ȵ���Ⱥ���� �����Ѿ����ȼ���������
end

