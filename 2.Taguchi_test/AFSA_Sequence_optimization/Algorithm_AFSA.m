function [Optimum_seq_afsa] = Algorithm_AFSA(kk1,init_pop,M,V,Num_ite,group_size,P_swam_1,delta,visual_range,Ref_point,Buf,Obj)
%% �Գ�ʼ��Ⱥ��ȡ����ȼ�Ϊ1�Ľ�
Optimum_seq_afsa = cell(Num_ite,2);
init_pop_dom = non_domination_sort_mod(init_pop, M, V);  % ��֧������
loc_front = M+V+1; % ����ȼ�����λ��
Q = Seq_optimum_set(init_pop_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
Q = Q(:,1:M+V); % ���pareto�ȼ�
Optimum_seq_afsa{1,1} = Q;
% Optimum_swarm = Seq_optimum_set(init_pop_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����
% Optimum_seq_afsa{1,1} = Optimum_swarm;% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
P_cross_swarm = 0.9;
cur_swarm = init_pop;
%% �˹���Ⱥ�㷨
%% ��ʼ����
for ite = 2:Num_ite % ���������ж�
    tic
    fprintf('���ڽ���AFSA�㷨��%d������,��%d�ε���,',kk1,ite);
    %% �˹���Ⱥ
    all_temp_swarm = [];
    for ii1=1:group_size
        random_operator=rand(1);
%         visual_range = 2*ceil(group_size*rand(1)/4+group_size/8);
        n_try = ceil(group_size/5) ;
        if  random_operator<=P_swam_1 % �������Ⱥ����Ϊ�������Ϊ
            temp_Q = afsa_swarm_behavior(ii1,cur_swarm,delta,visual_range,P_cross_swarm,n_try,Buf,Obj);
        else
            temp_Q = afsa_follow_behavior(ii1,cur_swarm,delta,visual_range,P_cross_swarm,n_try,Buf,Obj);
        end
        % ������Ⱥ
        all_temp_swarm = [all_temp_swarm;temp_Q];
    end
   %% ��Ⱥ����
    next_swarm = reduce_repetition(all_temp_swarm); % �����ظ�����
    cur_swarm = afsa_inferior_swam(next_swarm,M,V,group_size);    
    Q_swarm_dom = non_domination_sort_mod(cur_swarm,M,V);
    Optimum_swarm = Seq_optimum_set(Q_swarm_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����
    Q = Optimum_swarm(:,1:M+V); % ���pareto�ȼ�
    if size(Q,1)<=group_size
        Optimum_seq_afsa{ite,1} = Q;% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    else
        Optimum_seq_afsa{ite,1} = Q(1:group_size,:);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    end
    toc
end
%% HVָ������
for ite=1:Num_ite
    Optimum_seq_afsa{ite,2} = exam_hypervolume(Optimum_seq_afsa{ite,1},Ref_point); % ����hv�ε�����HVֵ
end
end