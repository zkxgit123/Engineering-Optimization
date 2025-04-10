function [non_dominate_follow]=iafsa_follow_behavior(fr,loc_swam,delta,visual_range,n_try,Buf,Obj)
V=1; % �����
M=4; % Ŀ�꺯��,P_cross_swam,P_muta_swam
group_size=size(loc_swam,1); % ��������
%% ����Χ���˹�������
a=1:1:group_size;
if fr>=1+visual_range/2 && fr<=group_size-visual_range/2
    visual_index=a(fr-visual_range/2:fr+visual_range/2);
elseif fr<1+visual_range/2
    visual_index=[a(end-visual_range/2+fr:end),a(1:fr+visual_range/2)];
else 
    visual_index=[a(fr-visual_range/2:end),a(1:fr-end+visual_range/2)];
end
%% �˹�����
swam_current=loc_swam(fr,:); 
visual_swam=loc_swam(visual_index,:);
visual_swam(visual_range/2+1,:) = [];
%% ӵ�����ж�
sup_num=0;
for ii1=1:length(visual_swam)
    ss = iafsa_dominant_judgement(swam_current,visual_swam(ii1,:),M,V);
    if  ss ~= 1
        sup_num=sup_num+1;    % ����swam_current�ŵĸ���
    end
end
%% �˹�����Ϊ
Q_follow = cell(1,V+M);
if  sup_num/visual_range > delta  % ̫����ӵ��ʱ��������ʳ��Ϊ
    Q_follow{1,1} = iafsa_predator(swam_current,visual_swam,visual_range,n_try,Buf);
else  % ������ӵ��ʱ
    % ȷ�����Ÿ���Xb
    visual_swam = non_domination_sort_mod(visual_swam, M, V);
    best_swam = visual_swam(1,:);
    seq_output = iafsa_cross_pollination(swam_current{1,1},best_swam{1,1},Buf);
    Q_follow{1,1} = seq_output;
end
%% �ж�֧���ϵ
Q_follow_object = new_objective(Q_follow{1,1},Obj);
Q_follow{1,2} = Q_follow_object(1,1);% ̼�ŷ���
Q_follow{1,3} = Q_follow_object(1,2);% �����ɱ�
Q_follow{1,4} = Q_follow_object(1,3);% ���Ͼ�����
Q_follow{1,5} = Q_follow_object(1,4);% ����������
judge_operator =cell(2,V+M);
judge_operator(1,:) = swam_current(1,1:V+M);
judge_operator(2,:) = Q_follow(1,1:V+M);
non_dominate_follow = iafsa_non_domination_solution(judge_operator, M, V);
end