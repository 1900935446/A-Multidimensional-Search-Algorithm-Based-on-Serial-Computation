%%
clear
clc
close all
number='F1'; %Select the optimization function and replace it by yourself: F1~F23
[lower_bound,upper_bound,variables_no,fobj]=CEC2005(number);  % [lb,ub,D,y]：Lower bound, upper bound, dimension, objective function expression
pop_size=50;                  % population members 
max_iter=50;                  % maximum number of iteration
for exp=1:30
 index=1;
%% MDA
[MDA_Score,MDA_pop,MDA_convergence_curve]=MDA(max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=MDA_Score;
index=index+1;
%% PSO
[PSO_Score,PSO_pop,PSO_convergence_curve]=PSO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=PSO_Score; 
index=index+1;
%% CDO
[CDO_Score,CDO_pop,CDO_convergence_curve]=CDO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=CDO_Score;
index=index+1;
%% GRO
[GRO_Score,GRO_pop,GRO_convergence_curve]=GRO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=GRO_Score;
index=index+1;
%% RIME
[RIME_Score,RIME_pop,RIME_convergence_curve]=RIME(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=RIME_Score;
index=index+1;
%% GWO
[GWO_Score,GWO_pop,GWO_convergence_curve]=GWO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=GWO_Score;
index=index+1;
%% SAO
[SAO_pop,SAO_Score,SAO_convergence_curve]=SAO(pop_size,max_iter,lower_bound,upper_bound,variables_no,fobj);
Afitness(index,exp)=SAO_Score;
%% 
end
index=7;
for i=1:index
aaMean(i)=mean(Afitness(i,:));
abMedian(i)=median(Afitness(i,:));
acStd(i)=std(Afitness(i,:));
end

 %% Figure
figure1 = figure('Color',[1 1 1]);
G1=subplot(1,2,1,'Parent',figure1);
func_plot(number)
title(number)
xlabel('x')
ylabel('y')
zlabel('z')
subplot(1,2,2)
G2=subplot(1,2,2,'Parent',figure1);
iter=1:1:max_iter;
if ~strcmp(number,'F16')&&~strcmp(number,'F9')&&~strcmp(number,'F11')  %这里是因为这几个函数收敛太快，不适用于semilogy，直接plot
    semilogy(iter,MDA_convergence_curve,'m','linewidth',3);
    hold on
    semilogy(iter,PSO_convergence_curve,'black','linewidth',1);
    hold on
    semilogy(iter,CDO_convergence_curve,'color','black','linewidth',1);
    hold on
    semilogy(iter,GRO_convergence_curve,'color','black','linewidth',1);
    hold on
    semilogy(iter,RIME_convergence_curve,'color','black','linewidth',1);
    hold on
    semilogy(iter,GWO_convergence_curve,'color','black','linewidth',1);
    hold on
    semilogy(iter,SAO_convergence_curve,'color','black','linewidth',1);
else
    plot(iter,MDA_convergence_curve,'m','linewidth',3);
    hold on
    plot(iter,PSO_convergence_curve,'black','linewidth',1); 
    hold on
    plot(iter,CDO_convergence_curve,'color','black','linewidth',1);
    hold on
    plot(iter,GRO_convergence_curve,'color','black','linewidth',1);
    hold on
    plot(iter,RIME_convergence_curve,'color','black','linewidth',1);
    hold on
    plot(iter,GWO_convergence_curve,'color','black','linewidth',1);
    hold on
    plot(iter,SAO_convergence_curve,'color','black','linewidth',1);
end
grid on;
title('收敛曲线')
xlabel('迭代次数');
ylabel('适应度值');
box on
legend('MDA','PSO','CDO','GRO','RIME','GWO','SAO')
set (gcf,'position', [300,300,800,330])
