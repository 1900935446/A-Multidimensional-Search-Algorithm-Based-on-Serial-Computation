function rmse=obj(x,inputnum,hiddennum,TF,P,T,TYPE)
%% inputnum 输入层节点数
%% hiddennum 隐含层节点数
%% TF 传递函数
%% TYPE 0表示回归预测  1表示分类预测

%提取
w1=x(1:inputnum*hiddennum);  %输入权值
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);  %隐层偏置
% LW1=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum*outputnum);

IW=reshape(w1,hiddennum,inputnum); %重构输入权值矩阵
B=reshape(B1,hiddennum,1);%重构隐层偏置
% LW=reshape(LW1,hiddennum,outputnum);
[IW,B,LW,TF,TYPE] = elmtrain1(IW,B,P,T,TF,TYPE);%将输入权值矩阵IW和隐层偏置B带入ELM训练
T_sim = elmpredict(P,IW,B,LW,TF,TYPE);% ELM预测
[m,n]=size(T_sim);
rmse=0;
for i=1:m
rmse=rmse+mean(sqrt((T(i,:)-T_sim(i,:)).^2));%计算rmse
end

