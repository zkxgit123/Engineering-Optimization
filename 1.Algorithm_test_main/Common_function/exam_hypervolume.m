function [value_of_hypervolume] = exam_hypervolume(seq_hv,Ref_point)
% seq_hvΪ�����Ż��������
%     V=1;
%     M=2;
    B1 = cell2mat(seq_hv(:,2)); % ̼�ŷ���
    B2 = cell2mat(seq_hv(:,3)); % �����ɱ�
    B3 = cell2mat(seq_hv(:,4)); % ���Ͼ�����
    B4 = cell2mat(seq_hv(:,5)); % ����������
%     max_delay = max(B1);
%     max_carbon = max(C1);
%     R0 = [ceil(max(B1))*1.2,ceil(max(C1))*1.2]; % �ο���
%     R0 = [x,y]; % �ο���
    obj_vector = [B1,B2,B3,B4]; % Ŀ�꺯������
    value_of_hypervolume = approximate_hypervolume_ms(obj_vector',Ref_point'); % ����hv�ε�����HVֵ
end
