%Butterfly optimization algorithm
% AroraS,SinghS.Butterflyoptimizationalgorithm:Anovel approach for global optimization [J].
% SoftComputing,2019,23 (3):715-734.
function [fmin,best_pos,Convergence_curve]=BOA(n,N_iter,Lb,Ub,dim,fobj)
% n is the population size
% N_iter represnets total number of iterations
p=0.8;                       % probabibility switch
power_exponent=0.1;
sensory_modality=0.01;

%Initialize the positions of search agents
Sol=initialization(n,dim,Ub,Lb);
for i=1:n
   Fitness(i)=fobj(Sol(i,:));
end
% Find the current best_pos
[fmin,I]=min(Fitness);
best_pos=Sol(I,:);
S=Sol; 

% Start the iterations -- Butterfly Optimization Algorithm 
for t=1:N_iter
        for i=1:n% Loop over all butterflies/solutions
           %Calculate fragrance of each butterfly which is correlated with objective function
          Fnew=fobj(S(i,:));
          FP=(sensory_modality*(Fnew^power_exponent));   
          %Global or local search
          if rand<p    
            dis = rand * rand * best_pos - Sol(i,:);        %Eq. (2) in paper
            S(i,:)=Sol(i,:)+dis*FP;
           else
              % Find random butterflies in the neighbourhood
              epsilon=rand;
              JK=randperm(n);
              dis=epsilon*epsilon*Sol(JK(1),:)-Sol(JK(2),:);
              S(i,:)=Sol(i,:)+dis*FP;                         %Eq. (3) in paper
         end
         % Check if the simple limits/bounds are OK
            S(i,:)=simplebounds(S(i,:),Lb,Ub);
            % Evaluate new solutions
            Fnew=fobj(S(i,:));  %Fnew represents new fitness values
            % If fitness improves (better solutions found), update then
            if (Fnew<=Fitness(i))
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
            end
        % Update the current global best_pos
           if Fnew<=fmin
                best_pos=S(i,:);
                fmin=Fnew;
           end
         end

         Convergence_curve(t,1)=fmin;
         %Update sensory_modality
         sensory_modality=sensory_modality_NEW(sensory_modality, N_iter);
end
end
% Boundary constraints
function s=simplebounds(s,Lb,Ub)
 % Apply the lower bound vector
temp = s;
I = temp < Lb;
temp(I) = Lb(I);

% Apply the upper bound vector
J = temp > Ub;
temp(J) = Ub(J);
% Update this new move
s = temp;
end
function y=sensory_modality_NEW(x,Ngen)
y=x+(0.025/(x*Ngen));
end