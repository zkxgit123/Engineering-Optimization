function loc_lane = GF_lane_choose_in(seq_in,Lane_sets,max_lane_num,type_bs)
%% 选择缓冲车道的位置
% 检索各车道车辆的数量和末尾对应颜色
Lane_size = size(Lane_sets,2);
last_type = zeros(1,Lane_size); % 车道存放末尾车辆的颜色、车型
stay_num = zeros(1,Lane_size); % 车道存放车辆的数量
Col_set = zeros(max_lane_num,Lane_size);
for ii3 = 1 : Lane_size 
    judge_lane = Lane_sets{1,ii3};
    [judge_lane_size,~] = size(judge_lane);
    if judge_lane_size ~= 0    % 缓冲车道不为空
       dif_col = unique(judge_lane(:,type_bs));
       Col_set(1:size(dif_col,1),ii3) = dif_col; % 颜色集合
       last_type(1,ii3) = judge_lane(judge_lane_size,type_bs); % 输出车道最后一辆车的颜色
       stay_num(1,ii3) = judge_lane_size;
    else  % 缓冲车道为空时
       Col_set(:,ii3) = 0;   % 空车道---颜色集合用0表示
       last_type(1,ii3) = 0; % 车道为空时，该车道输出0
       stay_num(1,ii3) = 0;
    end
end
%% 分配存放车道
% E_lane = find(stay_num(1,:) == 0);   % 空通道
cur_type = seq_in(1,type_bs);%% 分配存放车道
[~,j_lane] = find(last_type(1,:) == cur_type); % 末尾颜色相同的通道
if ~isempty(j_lane)  % 选择末尾颜色有相同
    cur_lane = min_inventory(stay_num,j_lane); % 选取存放最少的通道
    if  stay_num(1,cur_lane) < max_lane_num  % 通道有空位
        loc_lane = cur_lane;
    else
        loc_lane = different_type_inventory(Col_set,stay_num,Lane_size,max_lane_num,cur_type);
    end
else  % 末尾颜色没有相同 ,,选取颜色集合中与当前颜色不同的车道
    loc_lane = different_type_inventory(Col_set,stay_num,Lane_size,max_lane_num,cur_type);
end

end

function res_lane =  different_type_inventory(Col_set,stay_num,Lane_size,max_lane_num,cur_type)
%%  选取颜色集合中与当前颜色不同的车道
    ss = zeros(1,Lane_size);
    for ii1 = 1:Lane_size
        ss(1,ii1) = any(Col_set(:,ii1) == cur_type);
    end
    lane_all = 1:Lane_size;
    C_judge = lane_all(1,ss(1,:)~=1);
    if ~isempty(C_judge)
        cur_lane = min_inventory(stay_num,C_judge); % 选取存放最少的通道
        if  stay_num(1,cur_lane) < max_lane_num  % 通道有空位
            res_lane = cur_lane;
        else
            res_lane = min_inventory(stay_num,lane_all); % 选取存放最少的通道% 选取存放最少的通道
        end
    else
        res_lane = min_inventory(stay_num,lane_all); % 选取存放最少的通道% 选取存放最少的通道
    end
end

function res_lane = min_inventory(stay_num,in_lane)
% 选取存放最少的通道
    do_lane_job = 10000000;
    lane_size = size(in_lane,2);
    for ii3 = 1 : lane_size 
       if do_lane_job > stay_num(1,in_lane(ii3))
          do_lane_job = stay_num(1,in_lane(ii3));
          res_lane = in_lane(ii3);
       end
    end
end
