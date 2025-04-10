function [Optimum_seq_fpa] = Algorithm_DFPA2(kk1,init_pop,M,V,Num_ite,group_size,P_poll,Ref_point,Buf,Obj)
%% ��ʼ��Ⱥ��֧������
seq_iteration_fpa = cell(Num_ite,1);
init_pop_dom = non_domination_sort_mod(init_pop, M, V); % ��֧������
seq_iteration_fpa{1,1} = init_pop_dom; %��ų�ʼ��Ⱥ
loc_front = V+M+1;  % ����ȼ�����λ��
Optimum_seq_fpa = cell(Num_ite,3);
Optimum_seq_fpa{1,1} = Seq_optimum_set(init_pop_dom,loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
Optimum_seq_fpa{1,2} = exam_hypervolume(Optimum_seq_fpa{1,1},Ref_point);
%% FPA�����Ż�
for ite=2:Num_ite
    fprintf('���ڽ���DFPA�㷨��%d������,��%d�ε���,',kk1,ite);
    tic
    Parent_sequence = seq_iteration_fpa{ite-1,1};   % ǰһ��������Ⱥ
    Children_sequence = pollination(Parent_sequence,P_poll,Buf);% ���49���Ż���Ⱥ
    % �ڷ���Ⱥ���ʼ��Ⱥ����һ������/���з�֧������ȥ���ظ��⣬ѡȡǰ50���⣬��Ϊ��һ�λ��ڷ۵���Ⱥ��
    Parent_sequence(:,V+M+1:V+M+2)=[]; % ������ۣ�׼���������
    iteration_group = cell(2*group_size-1, V+M); % ����ռ�
    iteration_group(1:group_size,1:M+V)=Parent_sequence; % ���븸��
    iteration_group(group_size+1:2*group_size-1,1) = Children_sequence; % �����Ӵ�
    for jj1 = group_size+1 : 2*group_size-1
        res=new_objective(iteration_group{jj1,1},Obj); % Ŀ�꺯����ֵ
        iteration_group{jj1,2}=res(1,1);
        iteration_group{jj1,3}=res(1,2);
        iteration_group{jj1,4}=res(1,3);
        iteration_group{jj1,5}=res(1,4);
    end
    iteration_group_re = reduce_repetition(iteration_group); % ɾ���ظ�����
    % ����⼯
    iteration_group_non = non_domination_sort_mod(iteration_group_re, M, V); % pareto����
    seq_iteration_fpa{ite,1} = iteration_group_non(1:group_size,:); % ѡ��ǰ50%�Ľ��Ž��������
    %% ��ȡ����ȼ�Ϊ1�Ľ�
    Optimum_seq_fpa{ite,1} = Seq_optimum_set(seq_iteration_fpa{ite,1},loc_front,1);% �����ȼ�Ϊ1�ĽⱣ����Optimum_swam��
    Optimum_seq_fpa{ite,2} = exam_hypervolume(Optimum_seq_fpa{ite,1},Ref_point); % ����hv�ε�����HVֵ
    toc
    Optimum_seq_fpa{ite,3} = toc;
end
end

