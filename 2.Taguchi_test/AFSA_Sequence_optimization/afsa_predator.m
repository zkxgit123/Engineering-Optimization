function [final_individual] = afsa_predator(x_current,n_try,P_cross_swam,Buf,Obj)
V = 1;
M = 4; % Ŀ�꺯����
individual = x_current{1,1};
OrderSeq = individual(:,1:6);
%% ��ʳ��Ϊ
t = 1;
Q_prey = cell(0,0);
while t <= n_try
    % �������1������
    x_p1 = init_pop_maker(OrderSeq,Buf);
    x_cross = afsa_cross_operation_two_points(individual,x_p1,P_cross_swam,Buf); % ����֮��õ���������
    Q_prey_object = new_objective(x_cross,Obj);
    Q_prey{1,2} = Q_prey_object(1,1);% ̼�ŷ���
    Q_prey{1,3} = Q_prey_object(1,2);% �����ɱ�
    Q_prey{1,4} = Q_prey_object(1,3);% ���Ͼ�����
    Q_prey{1,5} = Q_prey_object(1,4);% ����������
    s1 = afsa_dominant_judgement(x_current,Q_prey,M,V);
    if  s1~=1   %��Ϊ1����ǰ������ţ���Ϊ2���������Ϊ�ţ���Ϊ0�򻥲�֧��
        final_individual = x_cross;
        break;
    else
     t=t+1;
    end
end
%% �����Ϊ
if t > n_try  % ����n_try֮����δ�ҵ����ŵĽ⣬����������Ϊ
    final_individual = init_pop_maker(OrderSeq,Buf);
end
end


