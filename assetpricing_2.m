function stat = smm(parm_beta);
global sigma d neps ud pi shckreal mutrue count
% r. cooper jan 2014 to illustrate use of fmins

beta=parm_beta;

Q=ud/(1-beta); 

count=count+1;
% ===============================
% Iterations: using this first guess at V iterate 
% ===============================
%T=input('maximal number of iterations')
Tvfi=200;

% here we set our tolerance for convergence on % difference between V and v
% (defined below)
toler=.00001;


for j=1:Tvfi;
q=ud+beta*pi*Q; % 

diff=abs((Q-q)./Q); % careful here in log case not to divide by zero
% test for diff significant difference

if diff <= toler
   break
else
% so here if the diff exceeds the tolerance, then do a replacement
% and go back to the top of the loop
     Q=q;
end
end



% now use it to generate q(d) using the params above

qreal=q(shckreal);


% compute a moment
mureal=mean(qreal);

stat=(mureal-mutrue)^2; % this is what we are minimizing
