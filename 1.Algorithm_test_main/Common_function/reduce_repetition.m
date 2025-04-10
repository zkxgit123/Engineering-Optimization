function [res_seq] = reduce_repetition(initial_group)
    %% 去除重复解
    [M_c,~] = size(initial_group); %叠加后种群的数量
    rep = [];
    for ii3 = 1:M_c
        for jj3 = (ii3+1):M_c
            if isequal(initial_group{ii3,1},initial_group{jj3,1})    % 将重复解的序号存放在rep中
                rep = [rep;jj3];
            end
        end
    end
    R = unique(rep);% 将重复解的序号罗列出来并排序
    [length,~] = size(R);
    if length>0  % 有重复解才执行此操作
        r=length;
        while r>0
            initial_group(R(r),:)=[]; % 删除重复行（从最后一个开始删除）
            r = r-1;
        end
    end
    res_seq = initial_group; %去重后种群的数量
end
