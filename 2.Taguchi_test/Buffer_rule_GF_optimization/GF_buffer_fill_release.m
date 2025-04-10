function [res_seq,res_record] = GF_buffer_fill_release(seq_in,Lane_size,max_lane_num,type_bs)
% seq_in--输入车身序列
% delay_time =0; % 延误次数
% max_lane_num 车道最大容纳数量
% type_bs=2,3 车型和颜色所在位置
%% 参数定义
[N,~] = size(seq_in);% 订单数量
Lane_sets = cell(1,Lane_size);  %生成车道集合
record_lane = zeros(N,2);
record_lane_sets = cell(1,Lane_size);
BS = Lane_size*max_lane_num;
WIP = ceil(BS*0.6);
In1 = 1; % 第*辆车-进站
Out1 = 1; % 第*辆车-出站
Out_seq = zeros(0,0); % 出站车身信息
while In1 <= N || Out1 <= N
    %% 进站
     if In1 < (N+1)
        % 分配存放车道
        In_seq = seq_in(In1,:);
        in_lane = GF_lane_choose_in(In_seq,Lane_sets,max_lane_num,type_bs);
        record_lane(In1,1) = in_lane; % 记录编号
        % 车身入库
        In_lane_seq = Lane_sets{1,in_lane};
        In_lane_seq = [In_lane_seq ; In_seq(:,:)];
        Lane_sets{1,in_lane} = In_lane_seq;
        % 记录入库车辆
        record_lane_seq = record_lane_sets{1,in_lane};
        record_lane_seq = [record_lane_seq ; In_seq(:,:)];
        record_lane_sets{1,in_lane} = record_lane_seq;
        In1 = In1+1;
     end
    %% 出站
    if  0<In1-WIP && Out1 <= N
        out_lane = GF_lane_choose_out(Out1,Out_seq,Lane_sets,type_bs);
        record_lane(Out1,2) = out_lane;% 记录编号
        out_lane_seq = Lane_sets{1,out_lane}; % 出站通道车辆序列
        Out_seq(Out1,:) = out_lane_seq(1,:);  % 出站序列
        out_lane_seq(1,:)=[];
        Lane_sets{1,out_lane} = out_lane_seq; % 刷新通道车辆序列
        out_lane_seq = [];
        Out1 = Out1+1;
    end
end
res_seq = Out_seq;
res_record = record_lane;
end
