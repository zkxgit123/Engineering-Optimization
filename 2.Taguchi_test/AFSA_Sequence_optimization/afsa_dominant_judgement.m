function [judgement_result] = afsa_dominant_judgement(x1,x2,M,V)
%DOMINANT_JUDGEMENT���ж�x��x_p1��֧���Թ�ϵ
%  �˴���ʾ��ϸ˵��
    dom_less = 0;
    dom_equal = 0;
    dom_more = 0;
    for k = 1 : M        %�жϸ���i�͸���j��֧���ϵ
        if (x1{1,V + k} < x2{1,V + k})     % ����1����  
            dom_less = dom_less + 1;
        elseif (x1{1,V + k} == x2{1,V + k})
            dom_equal = dom_equal + 1;
        else                             % ����2����  
            dom_more = dom_more + 1;
        end
    end
    if  dom_more > M/2
        judgement_result = 1;   % ˵��1��Ŀ�꺯��ֵ�����2�������ܸ���
    elseif dom_more == M/2
        judgement_result = -1; 
    else                        % ˵��2��Ŀ�꺯��ֵ�����1�������ܸ���
        judgement_result=0; 
    end
end

