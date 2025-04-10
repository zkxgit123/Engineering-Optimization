function f = iafsa_non_domination_solution(x, M, V)
% �ҳ��������塰�ȼ����ߡ��Ľ� 
% M:Ŀ�꺯��������  V:���߱�����ǰ������г��ȣ�
dom_less = 0;
dom_equal = 0;
dom_more = 0;
for k = 1 : M        %�жϸ���i�͸���j��֧���ϵ
    if (x{1,V + k} < x{2,V + k})     % ����1����  
        dom_less = dom_less + 1;
    elseif (x{1,V + k} == x{2,V + k})
        dom_equal = dom_equal + 1;
    else                             % ����2����  
        dom_more = dom_more + 1;
    end
end
if dom_less == 0 && dom_equal ~= M         % ˵��1��2֧��(����2����)
    f = x(2,:); % ���x(2,:)
elseif dom_more == 0 && dom_equal ~= M     % ˵��1֧��2  (����1����)
    f = x(1,:); % ���x(1,:)
else  % ���߻���֧��
    f = x;% ���1��2
end

end
