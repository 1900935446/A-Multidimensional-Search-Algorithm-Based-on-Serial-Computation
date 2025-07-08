% PSO
function [fitnessgbest,gbest,Afitness]=PSO(sizepop,iter,popmin,popmax,dim,fobj)    
Afitness=inf;
bestpop=zeros(1,dim);
%% input parameter
c1 = 0.5;
c2 = 0.5;
w=0.8;
Vmax = 10*ones(1,dim);
Vmin = -10*ones(1,dim);
%% Generate initial particles and velocity
pop=initialization(sizepop,dim,popmax,popmin); 
V=initialization(sizepop,dim,Vmax,Vmin);
for i = 1:sizepop
    fitness(i) = fobj(pop(i,:));
end
%% Individual extremum and group extremum
[bestfitness bestindex] = min(fitness); 
gbest = pop(bestindex,:); 
pbest = pop; 
fitnesspbest = fitness; 
fitnessgbest = bestfitness;
%% Iterative optimization
for i = 1:iter
    for j = 1:sizepop 
        V(j,:) = w*V(j,:) + c1*rand*(pbest(j,:) - pop(j,:)) + c2*rand*(gbest - pop(j,:));
        V(j,find(V(j,:)>Vmax(1,1))) = Vmax(1,1); 
        V(j,find(V(j,:)<Vmin(1,1))) = Vmin(1,1);
        pop(j,:) = pop(j,:) + V(j,:);
        pop(j,find(pop(j,:)>popmax(1,1))) = popmax(1,1);
        pop(j,find(pop(j,:)<popmin(1,1))) = popmin(1,1);
        fitness(j) = fobj(pop(j,:));
    end  
    for j = 1:sizepop
        if fitness(j) < fitnesspbest(j)
            pbest(j,:) = pop(j,:);
            fitnesspbest(j) = fitness(j);
        end
        if fitness(j) < fitnessgbest
            gbest = pop(j,:);
            fitnessgbest = fitness(j);
        end
    end
     Afitness(1,i)=fitnessgbest;
end
end
