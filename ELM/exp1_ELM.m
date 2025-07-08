clc; clear; close all
load('97.mat');load('105.mat');load('108.mat');load('130.mat');
%%  Load data
[num1,a1]=mapminmax(X097_DE_time(1:10000),0,1);
[num2,a2]=mapminmax(X105_DE_time(1:10000),0,1);
[num3,a3]=mapminmax(X108_DE_time(1:10000),0,1);
[num4,a4]=mapminmax(X130_DE_time(1:10000),0,1);
num1=num1';num2=num2';
num3=num3';num4=num4';
temp1=200;
num1=reshape(num1(1:10000)',temp1,[]);
num2=reshape(num2(1:10000)',temp1,[]);
num3=reshape(num3(1:10000)',temp1,[]);
num4=reshape(num4(1:10000)',temp1,[]);
features=[num1;num2;num3;num4];
for i=1:4
    classes((i-1)*temp1+1:i*temp1,1)=i;
end
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

%% ELM Training
[IW,B,LW,TF,TYPE] = elmtrain(XTrain,YTrain,60,'sig',1);

%%  ELM simulation testing
T_sim_1 = elmpredict(XTrain,IW,B,LW,TF,TYPE);
T_sim_2 = elmpredict(XTest,IW,B,LW,TF,TYPE);

%% 结果对比%% Comparison of Resultsresult_1 = [YTrain' T_sim_1'];
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
plot(1:temp1*0.2*4,YTest,'bo',1:temp1*0.2*4,T_sim_2,'r-*')
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
string = {'Average accuracy of each category in 20 experiments (%)'};
title(string)