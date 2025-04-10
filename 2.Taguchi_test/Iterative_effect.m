function Iterative_effect(Operat_Times,final_seq,Alg_total,Num_ite)
% 相应算法对应的第i次运算的迭代50次效果对比
% 算法种类：1-NSGA-II ; 2-AFSA ; 3-DAFSA
% 折线图绘制
% kk1=18;
for kk1=1:Operat_Times
    HV_value = zeros(0,0);
    % limit_HV = 1.0e+07;     % limit_HV为HV坐标值极限
    for jj1= 1 : Alg_total
        ans_set = final_seq{jj1,kk1};% 算法Alg_num运算kk1次之后存放的位置
        HV_value(:,jj1) =cell2mat(ans_set(:,2));
    end
    %% 折线图绘制
    figure(kk1);
    hold on;
    colors = lines(Alg_total);
    markers = {'d','o','^','*','+','sx'}; 
    it_num=1:1:Num_ite;  % x轴--迭代次数定义
    for j1=1:Alg_total
        plot(it_num,HV_value(:,j1),'color',colors(j1,:),'marker',markers{j1},'LineWidth',0.8,'MarkerIndices', 1:2:Num_ite);%color1(j1,:)/255
    end
    legend('NSGA-II','AFSA','DAFSA','Location','northwest');   %右上角标注
    %% 图片格式设置
    set(gca,'FontName','Times New Roman','FontSize',12);
    ylabel('Hypervolume','fontsize',12); %y轴坐标描述
    xlim([1,Num_ite]);
    set(gcf, 'Position', [100, 100, 800, 600]);
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    set(gcf,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
    set(gca,'xcolor','k');
    set(gca,'ycolor','k');
    print Line_600_50_50.jpg -djpeg -r600;%输出'3.jpg';3是图片名
% print Line_300.eps -depsc2 -r600 %输出'3.eps'
%% 订单数500
% axis([1,Num_ite,limit_HV*1.05,limit_HV*1.40])  %确定x轴与y轴框图大小
% set(gca,'XTick',[ 0 : 5 : Num_ite]) %x轴范围，间隔Number_iteration/10 
% set(gca,'YTick',[ limit_HV*1.05 : limit_HV/25 : limit_HV*1.40]) %y轴范围，间隔
% xticks(0:3:24);
% folder = 'Effect/';
% filename = sprintf('image_%d.emf',ff);
% saveas(gcf,fullfile(folder,filename),'emf');
% saveas(gcf,['./','N800_G100_I50','.emf']); 
end
end
