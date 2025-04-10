clc;
clear;
Mod_distribution = [0.25 0.25 0.25 0.25]; % 车型分配
Col_distribution = [0.02,0.02,0.03,0.05,0.07,0.09,0.15,0.19,0.38]; 
cc = size(Col_distribution,2);
cc1=1:1:cc;
Cumulated_Fre=zeros(1,cc);
for ii1=1:cc
    Cumulated_Fre(1,ii1+1) = Cumulated_Fre(1,ii1)+Col_distribution(1,ii1);
end
Cumulated_Fre = Cumulated_Fre(2:cc+1);
plot(cc1,Cumulated_Fre*100,'marker','^','MarkerEdgeColor','k','Color','k','LineWidth',0.8)
ylabel('Cumulated Frequencies','fontsize',12); %y轴坐标描述
set(gca,'FontName','Times New Roman','FontSize',10);
xticks(0:1:10);
xlim([0,10]);
ytickformat('percentage')
yticks(0:20:100);
grid on;
print Dc.jpg -djpeg -r600;%输出


