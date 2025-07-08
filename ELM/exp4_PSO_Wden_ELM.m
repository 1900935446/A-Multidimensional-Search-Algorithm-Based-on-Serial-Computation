clc; clear; close all
load('97.mat');load('105.mat');load('108.mat');load('130.mat');
%%  Wavelet processed data
[features,classes]=WDEN_Tsne(X097_DE_time,X105_DE_time,X108_DE_time,X130_DE_time);
temp1=200;
XTrain = [];YTrain = [];
XTest = [];YTest = [];
%% Dataset partitioning
for i = 1:4
    temp_input = features((i-1)*temp1+1:i*temp1,:);
    temp_output = classes((i-1)*temp1+1:i*temp1,:);
    n = randperm(temp1);
    % Training set
    XTrain = [XTrain temp_input(n(1:temp1*0.8),:)'];
    YTrain = [YTrain temp_output(n(1:temp1*0.8),:)'];
    % Test set
    XTest = [XTest temp_input(n(temp1*0.8+1:temp1),:)'];
    YTest = [YTest temp_output(n(temp1*0.8+1:temp1),:)'];
end
%% ELM Network Settings
inputnum=size(XTrain,1);
hiddennum=60;         % Number of hidden layer neurons
outputnum=1;           % Number of output layer neurons
Dim=inputnum*hiddennum+hiddennum;         %Optimize the total number of parameters/nodes for ELM
%% PSO parameters
xmin=-1; xmax=1; 
Vmin = -1;Vmax =1;
c1 = 4;          %learning factor
c2 = 4;
iter=50;         %Evolution times
sizepop=50;  %population
w = 0.9;
%% population initialization
for i = 1:sizepop
    x(i,:) = (xmax-xmin)*rand(1,Dim)+xmin;
    V(i,:)=Vmin+(Vmax-Vmin)*rand(1,Dim);
    fitness(i)=obj(x(i,:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
end
%% Calculate initial fitness
 for i=1:size(x,1)
    fitness(i)=obj1(x(i,:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
    V(i,:)=Vmin+(Vmax-Vmin)*rand(1,Dim);
end
%% Calculate the minimum value
[bestfitness,bestindex]=min(fitness);
zbest=x(bestindex,:);   % Global Best
gbest=x;                % Individual Best
fitnessgbest=fitness;     
fitnesszbest=bestfitness; 
%%  Iterative optimization
for i=1:iter
    for j=1:sizepop
        V(j,:) = V(j,:) + c1*rand*(gbest(j,:) - x(j,:)) + c2*rand*(zbest - x(j,:));
        for iV = 1:Dim
            V(j,iV) = min( Vmax,  V(j,iV));
            V(j,iV) = max( Vmin,  V(j,iV));
        end
        x(j,:) = x(j,:)+ V(j,:);
        for iV = 1:Dim
            x(j,iV) = min(xmax,x(j,iV));
            x(j,iV) = max(xmin,x(j,iV));
        end
        fitness(j) =obj1(x(j,:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
        if fitness(j)<fitnessgbest(j)
            fitnessgbest(j) = fitness(j);
            gbest(j,:) = x(j,:);
        end
        if fitness(j)<fitnesszbest
            fitnesszbest = fitness(j);
            zbest = x(j,:);
        end
    end
end
%% Extract optimal parameters
X=zbest;
w1=X(1:inputnum*hiddennum);  
B1=X(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);  
IW=reshape(w1,hiddennum,inputnum);
B=reshape(B1,hiddennum,1);
[IW,B,LW,TF,TYPE] = elmtrain1(IW,B,XTrain,YTrain,'sig',1);

%% ELM simulation testing
T_sim_1 = elmpredict(XTrain,IW,B,LW,TF,TYPE);
T_sim_2 = elmpredict(XTest,IW,B,LW,TF,TYPE);

%% Comparison of Results
result_1 = [YTrain' T_sim_1'];
result_2 = [YTest' T_sim_2'];
% Training set accuracy
k1 = length(find(YTrain == T_sim_1));
n1 = length(YTrain);
Accuracy_1 = k1 / n1 * 100;
disp(['训练集正确率Accuracy = ' num2str(Accuracy_1) '%(' num2str(k1) '/' num2str(n1) ')'])
% Test set accuracy
k2 = length(find(YTest == T_sim_2));
n2 = length(YTest);
Accuracy_2 = k2 / n2 * 100;
disp(['测试集正确率Accuracy = ' num2str(Accuracy_2) '%(' num2str(k2) '/' num2str(n2) ')'])

%% draw
figure(2)
plot(1:temp1*0.2*4,YTest,'bo',temp1*0.8,T_sim_2,'r-*')
grid on
Accuracy=zeros(4,4);
Accuracy1=0;
for j=1:10
N=size(T_sim_2,2);
accuracy=zeros(4,4);
accuracy1=0;
for i=1:N
    jx=YTest(1,i);
    jy=T_sim_2(1,i);
    accuracy(jx,jy)=accuracy(jx,jy)+1;
    if YTest(1,i)==T_sim_2(1,i)
    accuracy1=accuracy1+1;
    end
end
accuracy1=accuracy1/N*100;
Accuracy1=Accuracy1+accuracy1;
Accuracy=Accuracy+accuracy;
end
xname={'1','2','3','4'};
yname={'1','2','3','4'};
h=heatmap(xname,yname,Accuracy./10);
xlabel('Category labels')
ylabel('Category labels')
string = {'Classification results on the test set'};
title(string)