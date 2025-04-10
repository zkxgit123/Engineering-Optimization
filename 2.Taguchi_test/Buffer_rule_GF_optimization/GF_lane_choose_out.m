function [out_lane] = GF_lane_choose_out(Out1,Out_seq,Lane_paint_all,type_bs)
% do_lane_job = 100;
% out_lane = 0;
%% 检索各车道车辆的数量和末尾对应颜色
Lane_col_size = size(Lane_paint_all,2);
first_type = zeros(1,Lane_col_size); % 车道存放车辆的颜色\车型
stay_num = zeros(1,Lane_col_size); % 车道存放车辆的数量
first_num= zeros(1,Lane_col_size);
for i1 = 1 : Lane_col_size 
    judge_lane = Lane_paint_all{1,i1};
    [judge_lane_size,~] = size(judge_lane);
    if judge_lane_size ~= 0    % 缓冲车道不为空
        first_num(1,i1) = judge_lane(1,1);
       first_type(1,i1) = judge_lane(1,type_bs); % 输出车道第一辆车的颜色、车型
       stay_num(1,i1) = judge_lane_size;
    else  % 缓冲车道为空时
       first_num(1,i1) = 0; % 车道为空时，该车道输出0
       first_type(1,i1) = 0; % 车道为空时，该车道输出0
       stay_num(1,i1) = 0;
    end
end
%% 选取合适车道进行出站
if Out1==1
    [~,lane_all_in] = find(stay_num(1,:) > 0); 
    out_lane = min_delay(first_num,lane_all_in);
else
    cur_type = Out_seq(Out1-1,type_bs);
    [~,j_type] = find(first_type(1,:) == cur_type); % 首段颜色相同的通道
    if ~isempty(j_type)  % 车型、颜色相同 
        out_lane = min_delay(first_num,j_type);
    else  % 车型、颜色不同
        [~,lane_all_in] = find(stay_num(1,:) > 0); 
        out_lane = min_delay(first_num,lane_all_in);
    end
end
end
function res_lane = min_delay(first_num,lane_all_in)
    % 选取最少延迟的通道
    do_lane_job = 1000000;
    lane_size = size(lane_all_in,2);
    for ii3 = 1 : lane_size 
       if do_lane_job > first_num(1,lane_all_in(ii3))
          do_lane_job = first_num(1,lane_all_in(ii3));
          res_lane = lane_all_in(ii3);
       end
    end 
end