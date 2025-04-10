clc;
clear;
N = 200;
size_of_order = N;                  % 订单总量
%% 车型、颜色分配1
% Mod_distribution = [0.25 0.25 0.25 0.25]; % 车型分配
Mod_distribution = [0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125]; % 车型分配
% Col_distribution = [0.38,0.19,0.15,0.09,0.07,0.05,0.04,0.03]; 
% Col_distribution = [0.03,0.04,0.05,0.07,0.09,0.15,0.19,0.38]; 
% MC = {[1 2 3 4 6];[1 2 4 5 ];[1 2 3 6 8];[1 2 3 7]};
%% 车型、颜色分配2
% Mod_distribution = [0.25 0.25 0.25 0.25]; % 车型分配
% Col_distribution = [0.41,0.23,0.20,0.16]; % 颜色分配1
% MC = {[1 2 3 4];[1 2 3 4];[1 2 3 4];[1 2 3 4]};
mm = size(Mod_distribution,2);
mm1=1:1:mm;
Cumulated_Fre=zeros(1,mm);
for ii1=1:mm
    Cumulated_Fre(1,ii1+1) = Cumulated_Fre(1,ii1)+Mod_distribution(1,ii1);
end
Cumulated_Fre = Cumulated_Fre(2:mm+1);
plot(mm1,Cumulated_Fre*100,'marker','o','MarkerEdgeColor','k','Color','k','LineWidth',0.8)
ylabel('Cumulated Frequencies','fontsize',12); %y轴坐标描述
set(gca,'FontName','Times New Roman','FontSize',10);
xticks(0:1:10);
xlim([0,10]);
ytickformat('percentage')
yticks(0:20:100);
grid on;
print Dm.jpg -djpeg -r600;%输出


