function [judgement_result] = afsa_dominant_judgement(x1,x2,M,V)
%DOMINANT_JUDGEMENT：判定x和x_p1的支配性关系
%  此处显示详细说明
    dom_less = 0;
    dom_equal = 0;
    dom_more = 0;
    for k = 1 : M        %判断个体i和个体j的支配关系
        if (x1{1,V + k} < x2{1,V + k})     % 个体1更优  
            dom_less = dom_less + 1;
        elseif (x1{1,V + k} == x2{1,V + k})
            dom_equal = dom_equal + 1;
        else                             % 个体2更优  
            dom_more = dom_more + 1;
        end
    end
    if dom_less == 0 && dom_equal ~= M         % 说明1受2支配(个体2更优)     
        judgement_result=2;
    elseif dom_more == 0 && dom_equal ~= M     % 说明1支配2  (个体1更优)
        judgement_result=1;
    else
        judgement_result=0;
    end
end

