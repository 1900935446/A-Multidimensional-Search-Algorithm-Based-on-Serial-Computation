%%
clear
clc
close all
load '~~\MDA\CEC2005\CEC-DIMENTION\5-9\'05-9-500.mat''
Amean(:,5)=aaMean';
Amedian(:,5)=abMedian';
Astd(:,5)=acStd';
load '~~\MDA\CEC2005\CEC-DIMENTION\5-9\'05-9-100.mat''
Amean(:,4)=aaMean';
Amedian(:,4)=abMedian';
Astd(:,4)=acStd';
load '~~\MDA\CEC2005\CEC-DIMENTION\5-9\'05-9-50.mat''
Amean(:,3)=aaMean';
Amedian(:,3)=abMedian';
Astd(:,3)=acStd';
load '~~\MDA\CEC2005\CEC-DIMENTION\5-9\'05-9-30.mat''
Amean(:,2)=aaMean';
Amedian(:,2)=abMedian';
Astd(:,2)=acStd';
load '~~\MDA\CEC2005\CEC-DIMENTION\5-9\'05-9-10.mat''
Amean(:,1)=aaMean';
Amedian(:,1)=abMedian';
Astd(:,1)=acStd';

number='F12'; %Select the optimization function and replace it by yourself: F1~F23
[lower_bound,upper_bound,variables_no,fobj]=CEC2005(number);
pop_size=50;                      % population members 
max_iter=100;                  % maximum number of iteration
figure
% Amedian=log10(Amedian);
plot(Amedian(1,:),'LineWidth',2,'Linestyle','-','Marker','h');
hold on
plot(Amedian(2,:),'LineWidth',1.5,'Linestyle','--','Marker','+');
plot(Amedian(3,:),'LineWidth',1.5,'Linestyle','--','Marker','square');
plot(Amedian(4,:),'LineWidth',1.5,'Linestyle','--','Marker','diamond');
plot(Amedian(5,:),'LineWidth',1.5,'Linestyle','--','Marker','v');
plot(Amedian(6,:),'LineWidth',1.5,'Linestyle','--','Marker','^');
plot(Amedian(7,:),'LineWidth',1.5,'Linestyle','--','Marker','o');
xlabel('Dimention');
% ylabel('Log Fitness');
ylabel('Fitness');
title('F9-Median');

set(gca,'xtick',1:6); 
xticklabels({'10','30','50','100','500'}); 
legend('MDA','PSO','CDO','GRO','RIME','GWO','SAO')