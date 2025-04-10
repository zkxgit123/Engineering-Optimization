function [Q_prey] = iafsa_predator(swam_current,visual_swam,visual_range,n_try,Buf)
V = 1;
M = 4; % Ŀ�꺯����
Q_prey = cell(0,0);
t = 1;
%% ��ʳ��Ϊ
while t <= n_try    % ����n_try��Ѱ�ҽ��ŵĽ⣬������ʳ��Ϊ
    step_move = ceil(visual_range*rand(1,2));
    visual_swam_best = visual_swam(step_move,:);
    s1 = iafsa_dominant_judgement(swam_current,visual_swam(1,:),M,V);
    s2 = iafsa_dominant_judgement(swam_current,visual_swam(2,:),M,V);
    if  s1~=1 && s2~=1  %��Ϊ1����ǰ������ţ���Ϊ2���������Ϊ�ţ���Ϊ0�򻥲�֧��
        Q_prey = iafsa_self_pollination(swam_current{1,1},visual_swam_best{1,1},visual_swam_best{2,1},Buf);
        break;
    else
         t=t+1;
    end
end
%% �����Ϊ
while t > n_try  % ����n_try֮����δ�ҵ����ŵĽ⣬����������Ϊ
    visual_swam_random = visual_swam(ceil(visual_range*rand(1,2)),:);
    Q_prey = iafsa_self_pollination(swam_current{1,1},visual_swam_random{1,1},visual_swam_random{2,1},Buf);
    break;
end
end
