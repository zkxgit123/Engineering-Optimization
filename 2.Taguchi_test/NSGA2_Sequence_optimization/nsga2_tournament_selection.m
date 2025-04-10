function final_seq = nsga2_tournament_selection(init_pop_dom, pop_of_seq, tour_size)
% ***********************ѡ�����*******************************
% **************************************************************
% pool_size:��������Ⱥ�ĸ��������
% ��ȡ�ȼ�Ϊ
% V=1;
% M=2;
% loc_front = V+M+1;  % ����ȼ�����λ��
% final_seq = cell(pop_of_seq,V+M);
% final_seq = Seq_optimum_set(init_pop_dom,loc_front,1);  % �����ȼ�Ϊ1�ĽⱣ����Optimum_seq_fpa��
% num_front_1 = size(final_seq,1);
[pop, variables] = size(init_pop_dom); % �����Ⱥ�ĸ��������;��߱�������
rank = variables - 1; % ��������������ֵ����λ��(�����ڶ���)
distance = variables; % ����������ӵ��������λ�ã�������һ����
%������ѡ�񷨣�ÿ�����ѡ���������壬����ѡ������ȼ��ߵĸ��壬�������ȼ�һ������ѡѡ��ӵ���ȴ�ĸ���
for i = 1 : pop_of_seq % һ��ѭ������������
    for j = 1 : tour_size  % һ����ѡtour_size�����з�ѡ
        candidate(j) = round(pop*rand(1)); % ���ѡ���������
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            while ~isempty(find(candidate(1 : j - 1) == candidate(j), 1))%��ֹ��������������ͬһ��
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;
                end
            end
        end
    end
    c_obj_rank =[]; %cell(2,1);
    c_obj_distance =[];% cell(2,1);
    for j = 1 : tour_size % ��¼ÿ�������ߵ�����ȼ���ӵ����
        c_obj_rank(j,1) = cell2mat(init_pop_dom(candidate(j),rank));
        c_obj_distance(j,1) = cell2mat(init_pop_dom(candidate(j),distance));
    end
    min_candidate = find(c_obj_rank == min(c_obj_rank));%ѡ������ȼ���С�Ĳ����ߣ�find���ظò����ߵ�����
    if length(min_candidate) ~= 1    %������������ߵ�����ȼ���� ������Ƚ�ӵ���� ����ѡ��ӵ���ȴ�ĸ���
        max_candidate = find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate)));
        if length(max_candidate) ~= 1  % ��ӵ������ȵ�������������˶��ӵ������ȵĸ���
            max_candidate = max_candidate(unidrnd(2));
        end
        final_seq(i,:) = init_pop_dom(candidate(min_candidate(max_candidate)),:);
    else
        final_seq(i,:) = init_pop_dom(candidate(min_candidate(1)),:);
    end
end
