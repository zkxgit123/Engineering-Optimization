function [Q_prey] = iafsa_predator(swam_current,visual_swam,visual_range,n_try,Buf)
V = 1;
M = 4; % 目标函数量
Q_prey = cell(0,0);
t = 1;
%% 觅食行为
while t <= n_try    % 尝试n_try，寻找较优的解，进行觅食行为
    step_move = ceil(visual_range*rand(1,2));
    visual_swam_best = visual_swam(step_move,:);
    s1 = iafsa_dominant_judgement(swam_current,visual_swam(1,:),M,V);
    s2 = iafsa_dominant_judgement(swam_current,visual_swam(2,:),M,V);
    if  s1~=1 && s2~=1  %若为1，则当前个体更优，若为2则检索个体为优，若为0则互不支配
        Q_prey = iafsa_self_pollination(swam_current{1,1},visual_swam_best{1,1},visual_swam_best{2,1},Buf);
        break;
    else
         t=t+1;
    end
end
%% 随机行为
while t > n_try  % 尝试n_try之后若未找到更优的解，则进行随机行为
    visual_swam_random = visual_swam(ceil(visual_range*rand(1,2)),:);
    Q_prey = iafsa_self_pollination(swam_current{1,1},visual_swam_random{1,1},visual_swam_random{2,1},Buf);
    break;
end
end
