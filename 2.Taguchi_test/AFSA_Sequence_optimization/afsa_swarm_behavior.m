function [non_dominate_swam]=afsa_swarm_behavior(fr,loc_swam,delta,visual_range,P_cross_swam,n_try,Buf,Obj)
%% ��������
V=1; % �����
M=4; % Ŀ�꺯��
group_size = size(loc_swam,1); % ��������
%% ����Χ���˹�������
a=1:1:group_size;
if fr >= 1+visual_range/2 && fr<=group_size-visual_range/2
    visual_index=a(fr-visual_range/2:fr+visual_range/2);
elseif fr<1+visual_range/2
    visual_index=[a(end-visual_range/2+fr:end),a(1:fr+visual_range/2)];
else 
    visual_index=[a(fr-visual_range/2:end),a(1:fr-end+visual_range/2)];
end
%% �˹�����
swam_current = loc_swam(fr,:); 
visual_swam = loc_swam(visual_index,:);
visual_swam(visual_range/2+1,:) = [];
%% ӵ�����ж�
sup_num=0;
for ii1=1:length(visual_swam)
    ss = afsa_dominant_judgement(swam_current,visual_swam(ii1,:),M,V);
    if  ss ~= 1
        sup_num = sup_num+1;    % ����swam_current�ŵĸ���
    end
end
%% �˹�����Ϊ
Q_swarm = cell(1,V+M);
if  sup_num == 0
    Q_swarm{1,1} = afsa_predator(swam_current,n_try,P_cross_swam,Buf,Obj);  % û��ͬ���ʱ��ֱ�ӽ�����ʳ��Ϊ
else  % ��ͬ���ʱ��
    if  sup_num/visual_range>delta % ����ӵ��ֵҲֱ�ӽ�����ʳ��Ϊ
        Q_swarm{1,1} = afsa_predator(swam_current,n_try,P_cross_swam,Buf,Obj);   
    else
        % ȷ���м����Xc
        X_dominant_sort = non_domination_sort_mod(visual_swam,M,V);
        Xc = X_dominant_sort(visual_range/2+1,:); % ������ȷ����Xc
        s1 = afsa_dominant_judgement(swam_current,Xc,M,V);
        if  s1~=1   %��Ϊ1����ǰ�������
            Q_swarm{1,1} = Xc{1,1};
        elseif s1~=0
            Q_swarm{1,1}= afsa_cross_operation_two_points(swam_current{1,1},Xc{1,1},P_cross_swam,Buf); % ����֮��õ���������
        end
    end
end
    %% �ж�֧���ϵ
    Q_swarm_object = new_objective(Q_swarm{1,1},Obj);
    Q_swarm{1,2} = Q_swarm_object(1,1);% ̼�ŷ���
    Q_swarm{1,3} = Q_swarm_object(1,2);% �����ɱ�
    Q_swarm{1,4} = Q_swarm_object(1,3);% ���Ͼ�����
    Q_swarm{1,5} = Q_swarm_object(1,4);% ����������
    judge_operator =cell(2,V+M);
    judge_operator(1,:) = swam_current(1,1:V+M);
    judge_operator(2,:) = Q_swarm(1,1:V+M);
    non_dominate_swam = afsa_non_domination_solution(judge_operator, M, V);
end