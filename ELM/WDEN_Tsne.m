%  Wavelet processed data
function [features,classes]=WDEN_Tsne(X097_DE_time,X105_DE_time,X108_DE_time,X130_DE_time)
%%  Data Load
[num1,a1]=mapminmax(X097_DE_time(2001:12000),0,1);
[num2,a2]=mapminmax(X105_DE_time(2001:12000),0,1);
[num3,a3]=mapminmax(X108_DE_time(2001:12000),0,1);
[num4,a4]=mapminmax(X130_DE_time(2001:12000),0,1);
num1=num1';num2=num2';
num3=num3';num4=num4';
temp1=200;
%% Wavelet processing "h-hard threshold, s-soft threshold"
lev=3;
%Signal sequence after soft threshold denoising processing
num1=wden(num1,'heursure','s','one',lev,'db4');
num2=wden(num2,'heursure','s','one',lev,'db4');
num3=wden(num3,'heursure','s','one',lev,'db4');
num4=wden(num4,'heursure','s','one',lev,'db4');
%%Data Reconstruction
num1=reshape(num1(1:10000)',temp1,[]);
num2=reshape(num2(1:10000)',temp1,[]);
num3=reshape(num3(1:10000)',temp1,[]);
num4=reshape(num4(1:10000)',temp1,[]);
features=[num1;num2;num3;num4];
%% Trouble Ticketing
for i=1:4
    classes((i-1)*temp1+1:i*temp1,1)=i;
end
end