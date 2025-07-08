%  Gold Rush Optimizer (GRO)  
%
%  Source code version 1.0                                                                      
%                                                                                                     
%  Developed in MATLAB R2013b(v 8.2)                                                                   
%                                                                                                     
%  Author and programmer: Kamran Zolfi                                                          
%                                                                                                     
%  e-Mail: zolfi@iauln.ac.ir   
%          kamran.zolfi@gmail.com    
%  main article:
%           Gold Rush optimizer. A new population-based metaheuristic algorithm
%           DOI: 10.37190/ord230108
%           journal: Operations Research and Decisions
%           Vol. 33, No. 1 (2023)
%%

%This function is used for GRO bound checking
function newPos = boundConstraint(newPos, oldPos , lb, ub)

[NP, ~] = size(newPos);  % the Population size and the problem's dimension
%% check the lower bound
xl = repmat(lb, NP, 1);
pos = newPos < xl;
newPos(pos) =    oldPos(pos)  ;

%% check the upper bound
xu = repmat(ub, NP, 1);
pos = newPos > xu;
newPos(pos) =    oldPos(pos)  ;

end