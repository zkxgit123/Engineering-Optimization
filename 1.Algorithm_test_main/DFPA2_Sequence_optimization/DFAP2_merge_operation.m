function [final_mod_seq,random_number] = DFAP2_merge_operation(not_online,C_moding_maker)
%% 构建初始焊装序列
[N,~] = size(not_online);    % 订单数量
final_mod_seq=[];
for aa1=1:N
    judge_make=C_moding_maker(aa1);
    if  aa1==1 || judge_make==0   % 选取订单编号最小的订单
        [~,loc_row]=min(not_online(:,2));
        final_mod_seq=[final_mod_seq;not_online(loc_row,:)];
        not_online(loc_row,:)=[];
    else  % 选取车型相同且编号最小的订单
        cur_mod=final_mod_seq(end,3);
        same_mod=find(not_online(:,3)==cur_mod);
        if ~isempty(same_mod)   % 若还有未上线的同型可提取
            loc_row=same_mod(1);
            final_mod_seq=[final_mod_seq;not_online(loc_row,:)];
            not_online(loc_row,:)=[];
        else                    % 否则提取编号最小
            [~,loc_row]=min(not_online(:,2));
            final_mod_seq=[final_mod_seq;not_online(loc_row,:)];
            not_online(loc_row,:)=[];
        end
    end  
end
end

