clc;clear all;close all;
%% Initialization
sizepop=50;   %Population size
iter=50;          %Maximum Number Of Iterations
dim=20;         %Can be taken as 10, 20
%% Function selection
Function_name=5;   %F1—F12
[lb,ub,dim,fobj]=Get_Functions_cec2022(Function_name,dim);
%% 调用函数
for exp=1:30
Optimal_results={}; 
index=1;
% MDA
tic
[Best_score,Best_pos,cg_curve]=MDA(iter,lb,ub,dim,fobj);
Optimal_results{1,index}="MDA";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=3;
Optimal_results{7,index}="-";
index=index+1;
% WOA
tic
[Best_score,Best_pos,cg_curve]=WOA(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="WOA";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";
index = index +1;
% HHO
tic
[Best_score,Best_pos,cg_curve]=HHO(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="HHO";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";
index = index +1;
% PSO
tic
[Best_score,Best_pos,cg_curve]=PSO(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="PSO";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";
index = index +1;
% BOA
tic
[Best_score,Best_pos,cg_curve]=BOA(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="BOA";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";
index = index +1;
% GWO
tic
[Best_score,Best_pos,cg_curve]=GWO(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="GWO";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";
index = index +1;
% CDO
tic
[Best_score,Best_pos,cg_curve]=CDO(sizepop,iter,lb,ub,dim,fobj);
Optimal_results{1,index}="CDO";
Optimal_results{2,index}=cg_curve;
Optimal_results{3,index}=Best_score;
Optimal_results{4,index}=Best_pos;
Optimal_results{5,index}=toc;
Optimal_results{6,index}=1;
Optimal_results{7,index}="--";

    for i=1:index
        Afitness(i,exp)=Optimal_results{3,i};
    end
end
for i=1:index
aaMean(i)=mean(Afitness(i,:));
abMedian(i)=median(Afitness(i,:));
acStd(i)=std(Afitness(i,:));
end
%% plot
figure
for i = 1:size(Optimal_results, 2)
    plot(Optimal_results{2, i},'Linewidth',Optimal_results{6, i},'Linestyle',Optimal_results{7, i})
    hold on
end
title(['Convergence curve, Dim=' num2str(dim)],'FontSize',13);
xlabel('Iteration','FontSize',13);
ylabel(['Best score F' num2str(Function_name) ],'FontSize',13);
axis tight
grid off
box on
set(gcf,'Position',[400 200 400 250])
legend(Optimal_results{1, :})
legend off