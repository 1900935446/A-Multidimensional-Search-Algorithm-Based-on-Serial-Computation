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
hiddennum=60;  % Number of hidden layer neurons
outputnum=1;    % Number of output layer neurons
dim=inputnum*hiddennum+hiddennum;   %Optimize the total number of parameters/nodes for ELM
%% MDA parameters
popmin=-1*ones(1,dim);popmax=1*ones(1,dim);
xmin=-1; % lb
xmax=1; % ub
iter=50;  %T
%% Starting position determination
pop=initialization(50,dim,popmax,popmin);
for i = 1:50
    Fitness(i)=obj1(pop(i,:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
end
[~,bestindex] = min(Fitness);
bestpop = pop(bestindex,:);
Bestpop=bestpop;
%% Internal parameter settings
fitness =obj1(bestpop,inputnum,hiddennum,'sig',XTrain,YTrain,1);
fitnessgbest=fitness;
gbest=bestpop;
n=10;
S=3;
tmax=popmax(1,1);
tmin=-tmax;
%% Multidimensional serial search
for i = 1:iter 
    y=randperm(dim);
     for j=1:dim
        besttemp=zeros(1,5);
        Tmax=tmax;
        Tmin=tmin;
        Scope=Tmin:(Tmax-Tmin)/n:Tmax;
        for s=1:S
            for m=1:n+1  %s=1: Step1-2; s>1:Step4
                [temp(m,:),value(m)]=TEMP(besttemp,bestpop,Scope(m),y(j),popmax,popmin,inputnum,hiddennum,XTrain,YTrain);
            end     
            [~,index]=min(value(:));
            besttemp(1,s)=Scope(index);
            Tmax=Tmax/n;  %Step3
            Tmin=Tmin/n;
             Scope=Tmin:(Tmax-Tmin)/n:Tmax;
             %Step5
             a1=obj1(bestpop,inputnum,hiddennum,'sig',XTrain,YTrain,1);
             a2=obj1(temp(index,:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
            if a1>a2
                bestpop=temp(index,:);
            end    
        end
     end
       %% Position mutation
    fitness = obj1(bestpop,inputnum,hiddennum,'sig',XTrain,YTrain,1);
    if fitness<fitnessgbest
        fitnessgbest=fitness;
        gbest=bestpop;
    end
    if Bestpop~=bestpop
        Bestpop=bestpop;
    else
        z=randperm(50);
        a1=obj1(pop(z(1),:),inputnum,hiddennum,'sig',XTrain,YTrain,1);
        a2=obj1(bestpop,inputnum,hiddennum,'sig',XTrain,YTrain,1);
        a=1/(a1+a2);
       bestpop=a*(a1*bestpop+a2*pop(z(1),:)); 
       Bestpop=bestpop;
    end
 Afitness(1,i)=fitnessgbest;
 end 
%% Extract optimal parameters
X=gbest;
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
for j=1:N
    jx=YTest(1,j);
    jy=T_sim_2(1,j);
    accuracy(jx,jy)=accuracy(jx,jy)+1;
    if YTest(1,j)==T_sim_2(1,j)
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
string = {'Average accuracy of each category in 30 experiments (%)'};
title(string)
 

function [temp,value]=TEMP(besttemp,bestpop,Scope,y,popmax,popmin,inputnum,hiddennum,P_train,T_train)  
temp=bestpop;
temp(1,y)=Scope+sum(besttemp);
temp(find(temp>popmax(1,1)))=popmax(1,1);
temp(find(temp<popmin(1,1))) = popmin(1,1);
value=obj1(temp,inputnum,hiddennum,'sig',P_train,T_train,1);
end