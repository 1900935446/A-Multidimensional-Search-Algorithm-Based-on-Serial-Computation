function rmse=obj(x,inputnum,hiddennum,TF,P,T,TYPE)
%% inputnum �����ڵ���
%% hiddennum ������ڵ���
%% TF ���ݺ���
%% TYPE 0��ʾ�ع�Ԥ��  1��ʾ����Ԥ��

%��ȡ
w1=x(1:inputnum*hiddennum);  %����Ȩֵ
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);  %����ƫ��
% LW1=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum*outputnum);

IW=reshape(w1,hiddennum,inputnum); %�ع�����Ȩֵ����
B=reshape(B1,hiddennum,1);%�ع�����ƫ��
% LW=reshape(LW1,hiddennum,outputnum);
[IW,B,LW,TF,TYPE] = elmtrain1(IW,B,P,T,TF,TYPE);%������Ȩֵ����IW������ƫ��B����ELMѵ��
T_sim = elmpredict(P,IW,B,LW,TF,TYPE);% ELMԤ��
[m,n]=size(T_sim);
rmse=0;
for i=1:m
rmse=rmse+mean(sqrt((T(i,:)-T_sim(i,:)).^2));%����rmse
end

