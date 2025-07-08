%  Multidimensional Search Algorithm (MDA)
%  Developed in MATLAB R2020a
%
%  programmer: Xinjie Hu and Wenxin Yu   
%  E-mail: huxinjie@163.com
%              1040118@hnust.edu.cn
%  The code is based on the following papers.
%  Xinjie Hu, Wenxin Yu*, Qiumei Xiao, Qizheng Zhao
%  A Multidimensional Search Algorithm Based on Serial Computation for Solving Ultra-High Dimensional Optimization Problems
%  Applied Intelligence

function [fitnessgbest,gbest,Afitness]=MDA(iter,popmin,popmax,dim,fobj)    
Afitness=inf;
%% Starting position determination
pop=initialization(50,dim,popmax,popmin); 
for i = 1:50
    Fitness(i) = fobj(pop(i,:));
end
[~,bestindex] = min(Fitness); 
bestpop = pop(bestindex,:); 
%% Internal parameter settings
fitness = fobj(bestpop);
fitnessgbest=fitness;
gbest=bestpop;
n=10;
S=5;
tmax=popmax(1,1);
tmin=popmin(1,1);
%% Multidimensional serial search
for i = 1:iter
    y=1:1:20;
    for j=1:dim
        besttemp=zeros(1,S);
        Tmax=tmax;
        Tmin=tmin;
        Scope=Tmin:(Tmax-Tmin)/n:Tmax;
        for s=1:S
            for m=1:n+1     %s=1: Step1-2; s>1:Step4
                [temp(m,:),value(m)]=TEMP(besttemp,bestpop,Scope(m),y(j),popmax,popmin,fobj);  
            end     
            [~,index]=min(value(:));
            besttemp(1,s)=Scope(index);
            Tmax=Tmax/n;  %Step3
            Tmin=Tmin/n;
             Scope=Tmin:(Tmax-Tmin)/n:Tmax;
            if fobj(bestpop)>fobj(temp(index,:))   %Step5
                bestpop=temp(index,:);
            end      
        end
    end
  %% Position mutation
    fitness = fobj(bestpop); 
    if fitness<fitnessgbest
        fitnessgbest=fitness;
        gbest=bestpop;
    else
        z=randperm(50);
        a1=fobj(pop(z(1),:));
        a2=fobj(bestpop);
        a=1/(a1+a2);
       bestpop=a*(a1*bestpop+a2*pop(z(1),:)); 
    end
     Afitness(1,i)=fitnessgbest;
end

end
function [temp,value]=TEMP(besttemp,bestpop,Scope,y,popmax,popmin,fobj)  
temp=bestpop;  %Step1
temp(1,y)=Scope+sum(besttemp);  %Stemp2
temp(find(temp>popmax(1,1)))=popmax(1,1);
temp(find(temp<popmin(1,1))) = popmin(1,1);
value=fobj(temp);
end
