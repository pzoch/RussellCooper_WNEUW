% r cooper 
% revised dec. 2005
% dec. 2004
% value function iteration for
% stochastic discrete cake eating



clear all


% Basic Parameters

% u(c)=c.^(1-sigma)/(1-sigma);
sigma=1.05;

quad=0; % turns on quad spec of utility
beta=0.95;
% what is the growth rate for cake?
rho=.99;

% SPACES

% size of the state space for cake
N=100;

Khi=100; % biggest cake
J=0:1:100;
delfac=rho.^J;
K=fliplr((Khi*delfac)); 
% this gives us the cake space starting at Khi
% the order matters to bring in depreciation of the cake
clear delfac;
% n is the true length of the state space

n=length(K);
if rho==1
    K=100;
    N=1;
end
% taste shocks
%epsi=[.85 1.15]; % space for taste shock
%pi=[.9 .1;.1 .9] ; % transition matrix where today's state is the row
epsi=[0.65 1.0 1.25]; % space for taste shock
pi=[.90 .05 0.05;0.05 0.9 0.05;.05 0.05 .9] ; % transition matrix where today's state is the row
neps=length(epsi); % length of taste shocks

% first guess of the value function 

%eat the cake and then we are done with the problem
% so use VE below too.
VE=ones(neps,n);
for i=1:neps
    if sigma==1
        VE(i,:)=epsi(i)*log(K);
    elseif quad==1
        VE(i,:)=epsi(i)*K+.5*K.^2;

    else
    VE(i,:)=epsi(i)*K.^(1-sigma)/(1-sigma);
end
end

% or try lq
% if you don't eat the cake, then it is rho smaller the next period
% this means you move down the state space
VW=beta*pi*VE; % the first col here is not relevant as you will not go there
V=max(VE,VW); % obviously the max is to eat the cake
V=VE;
% ===============================
% Iterations: using this first guess at V iterate 
% ===============================
%T=input('maximal number of iterations')
T=200;
% here we set our tolerance for convergence
toler=.00001;

% now keep doing the code from above as we loop and loop and..

% here T is the number of iterations

for j=1:T;
VW=beta*pi*[VE(:,1) V(:,1:n-1)]; % the first col here is not relevant as you will not go there
v=max(VE,VW); % obviously the max is to eat the cake in the lowest state of K

diff=abs((V-v)./V); % careful here in log case not to divide by zero

% test for diff significant difference

if diff <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     V=v;
end
end
j
Z=(VE>VW);
