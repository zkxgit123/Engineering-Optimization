function [value_of_hypervolume] = exam_hypervolume(seq_hv,Ref_point)
% seq_hv为迭代优化后的数组
%     V=1;
%     M=2;
    B1 = cell2mat(seq_hv(:,2)); % 碳排放量
    B2 = cell2mat(seq_hv(:,3)); % 生产成本
    B3 = cell2mat(seq_hv(:,4)); % 物料均衡率
    B4 = cell2mat(seq_hv(:,5)); % 总拖期延误
%     max_delay = max(B1);
%     max_carbon = max(C1);
%     R0 = [ceil(max(B1))*1.2,ceil(max(C1))*1.2]; % 参考点
%     R0 = [x,y]; % 参考点
    obj_vector = [B1,B2,B3,B4]; % 目标函数矩阵
    value_of_hypervolume = approximate_hypervolume_ms(obj_vector',Ref_point'); % 求解第hv次迭代的HV值
end
