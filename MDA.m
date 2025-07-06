function [fitnessgbest,gbest,Afitness]=MDA(iter,popmin,popmax,dim,fobj)    
Afitness=inf;

%% rand随机
pop=initialization(50,dim,popmax,popmin);   %初始种群
for i = 1:50
    Fitness(i) = fobj(pop(i,:));
end
[~,bestindex] = min(Fitness); %bestindex:全局最优粒子索引
bestpop = pop(bestindex,:);   %全局最佳位置
Bestpop=bestpop;

%% 种群初始化
fitness = fobj(bestpop);
fitnessgbest=fitness;
gbest=bestpop;
n=10;
tmax=popmax(1,1);
tmin=-tmax;

%% 迭代寻优
for i = 1:iter       %代数更迭
%     y=randperm(dim);
    y=1:1:20;
    for j=1:dim
        besttemp=zeros(1,5);
        Tmax=tmax;
        Tmin=tmin;
        Scope=Tmin:(Tmax-Tmin)/n:Tmax;
        for cyc=1:5
            for m=1:n+1
                [temp(m,:),value(m)]=TEMP(besttemp,bestpop,Scope(m),y(j),popmax,popmin,fobj);
            end     
            [~,index]=min(value(:));
            besttemp(1,cyc)=Scope(index);
            Tmax=Tmax/n;
            Tmin=Tmin/n;
             Scope=Tmin:(Tmax-Tmin)/n:Tmax;
            if fobj(bestpop)>fobj(temp(index,:))
                bestpop=temp(index,:);
            end
        % 适应度值更新         
        end
    end
    fitness = fobj(bestpop); 
    if fitness<fitnessgbest
        fitnessgbest=fitness;
        gbest=bestpop;
    else
        z=randperm(50);
        a1=fobj(pop(z(1),:));
%         a2=fobj(Bestpop);
        a3=fobj(bestpop);
        a=1/(a1+a3);
       bestpop=a*(a1*bestpop+a3*pop(z(1),:)); 
%         a1=fobj(pop(z(1),:))+fobj(Bestpop);
%         a2=fobj(Bestpop)+fobj(bestpop);
%         a3=fobj(bestpop)+fobj(pop(z(1),:));
%         a=2/(a1+a2+a3);        
%         bestpop=a*(a1*bestpop+a2*pop(z(1),:)+a3*Bestpop);
    end
     Afitness(1,i)=fitnessgbest;
end

end
function [temp,value]=TEMP(besttemp,bestpop,Scope,y,popmax,popmin,fobj)  
temp=bestpop;
temp(1,y)=Scope+sum(besttemp);
temp(find(temp>popmax(1,1)))=popmax(1,1);
temp(find(temp<popmin(1,1))) = popmin(1,1);
value=fobj(temp);
end
