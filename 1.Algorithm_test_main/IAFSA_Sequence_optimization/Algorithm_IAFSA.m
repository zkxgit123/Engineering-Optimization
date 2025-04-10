function [Optimum_seq_iafsa] = Algorithm_IAFSA(kk1,init_pop,M,V,Num_ite,group_size,P_swam,delta,visual_range,Ref_point,Buf,Obj)
%% �Գ�ʼ��Ⱥ��ȡ����ȼ�Ϊ1�Ľ�
Optimum_seq_iafsa = cell(Num_ite,2);
init_pop_dom = non_domination_sort_mod(init_pop, M, V);  % ��֧������
loc_front = M+V+1; % ����ȼ�����λ��
Q = Seq_optimum_set(init_pop_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
Q = Q(:,1:M+V); % ���pareto�ȼ�
Optimum_seq_iafsa{1,1} = Q;
% Optimum_swarm = Seq_optimum_set(init_pop_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����
% Optimum_seq_iafsa{1,1} = Optimum_swarm;% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
loc_swam = init_pop; % ��ǰ��Ⱥλ��
%% �˹���Ⱥ�㷨
% ��ʼ����
for ite = 2:Num_ite % ���������ж�
    fprintf('���ڽ���IAFSA�㷨��%d������,��%d�ε���,',kk1,ite);
    tic
    temp_new_swam = cell(0,0);  % ����һ����ʱ���飬�������ǰ�������Ⱥ
    for s1=1:group_size  % ��ÿ���㶼����
        random_operator = rand(1);
%         visual_range = 2*ceil(group_size*rand(1)/4+group_size/5);
        n_try = ceil(group_size/5) ;
        if  random_operator <= P_swam   % ����һ����������������Ⱥ�ۺ�׷β��Ϊ
            temp_next_state = iafsa_swarm_behavior(s1,loc_swam,delta,visual_range,n_try,Buf,Obj);   % Ⱥ����Ϊ
        else                       
            temp_next_state = iafsa_follow_behavior(s1,loc_swam,delta,visual_range,n_try,Buf,Obj);  % ׷β��Ϊ
        end
        temp_new_swam = [temp_new_swam;temp_next_state];% ������Ⱥ
    end
    new_swam = reduce_repetition(temp_new_swam); % �����ظ�����
    loc_swam = iafsa_inferior_swam(new_swam,M,V,group_size);    
    % �����µķ��ӽ�
    renewed_Q = [Q;loc_swam]; % ���������ɵķ��ӽ�
    renewed_Q = reduce_repetition(renewed_Q); % �����ظ�����
    new_swam_dom = non_domination_sort_mod(renewed_Q,M,V);
    Optimum_swarm = Seq_optimum_set(new_swam_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����
    Q = Optimum_swarm(:,1:M+V); % ���pareto�ȼ�
    if size(Q,1)<=group_size
        Optimum_seq_iafsa{ite,1} = Q;% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    else
        Optimum_seq_iafsa{ite,1} = Q(1:group_size,:);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    end
%     Q_swarm_dom = non_domination_sort_mod(loc_swam,M,V);
%     Optimum_swarm = Seq_optimum_set(Q_swarm_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����
%     Optimum_seq_iafsa{ite,1} = Optimum_swarm;% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    toc
end
%% HVָ������
for ite=1:Num_ite
    Optimum_seq_iafsa{ite,2} = exam_hypervolume(Optimum_seq_iafsa{ite,1},Ref_point); % ����hv�ε�����HVֵ
end
end