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
popmin = popmin .* ones(1, dim);
popmax = popmax .* ones(1, dim);
pop=initialization(50,dim,popmax,popmin);
for i = 1:50
    Fitness(i) = fobj(pop(i,:));
end
[~,bestindex] = min(Fitness); 
bestpop = pop(bestindex,:); 
Afitness(1)=Fitness(bestindex);

%% Internal parameter settings
fitness = fobj(bestpop);
fitnessgbest=fitness;
gbest=bestpop;
n=10;
S=5;
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
            for m=1:n+1
                [temp(m,:),value(m)]=TEMP(besttemp,bestpop,Scope(m),y(j),popmax,popmin,fobj);
            end     
            [~,index]=min(value(:));
            besttemp(1,s)=Scope(index);
            Tmax=Tmax/n;
            Tmin=Tmin/n;
             Scope=Tmin:(Tmax-Tmin)/n:Tmax;
            if fobj(bestpop)>fobj(temp(index,:))
                bestpop=temp(index,:);
            end       
        end
    end
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
    if i~=iter
     Afitness(1,i+1)=fitnessgbest;
    end
end

end
function [temp,value]=TEMP(besttemp,bestpop,Scope,y,popmax,popmin,fobj)  
temp=bestpop;
temp(1,y)=Scope+sum(besttemp);
temp(find(temp>popmax(1,1)))=popmax(1,1);
temp(find(temp<popmin(1,1))) = popmin(1,1);
value=fobj(temp);
end
