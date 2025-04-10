function [C1_assembly,C2_assembly] = afsa_cross_ox(P1_assembly,P2_assembly)
    % 交叉点选取
    [N,~] = size(P1_assembly); % 订单序列的行数
    L1=zeros(1,2);
    cross_point = rand(1,2);
    L1(1,1) = ceil(min(cross_point)*N);% 交叉位置1
    L1(1,2) = ceil(max(cross_point)*N);% 交叉位置2
    part1 = P1_assembly(L1(1,1):L1(1,2),:);
    part2 = P2_assembly(L1(1,1):L1(1,2),:);
    cur_ass_1 = P1_assembly;
    for ii1 = 1:size(part2,1)
        del_car_1 = find(cur_ass_1(:,1) == part2(ii1,1));
        cur_ass_1(del_car_1,:) = [];
    end
    C1_assembly = [cur_ass_1(1:L1-1,:);part2;cur_ass_1(L1:end,:)];
    cur_ass_2 = P1_assembly;
    for ii2 = 1:size(part1,1)
        del_car_2 = find(cur_ass_2(:,1) == part1(ii2,1));
        cur_ass_2(del_car_2,:) = [];
    end
    C2_assembly = [cur_ass_2(1:L1-1,:);part1;cur_ass_2(L1:end,:)];
end
