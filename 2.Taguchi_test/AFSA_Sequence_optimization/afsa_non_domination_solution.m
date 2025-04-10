function f = iafsa_non_domination_solution(x, M, V)
% 找出两个个体“等级更高”的解 
% M:目标函数的数量  V:决策变量（前面的序列长度）
dom_less = 0;
dom_equal = 0;
dom_more = 0;
for k = 1 : M        %判断个体i和个体j的支配关系
    if (x{1,V + k} < x{2,V + k})     % 个体1更优  
        dom_less = dom_less + 1;
    elseif (x{1,V + k} == x{2,V + k})
        dom_equal = dom_equal + 1;
    else                             % 个体2更优  
        dom_more = dom_more + 1;
    end
end
if dom_less == 0 && dom_equal ~= M         % 说明1受2支配(个体2更优)
    f = x(2,:); % 输出x(2,:)
elseif dom_more == 0 && dom_equal ~= M     % 说明1支配2  (个体1更优)
    f = x(1,:); % 输出x(1,:)
else  % 两者互不支配
    f = x;% 输出1和2
end

end
