Ts=0.5;

clc
% Generate the MLD model
S=mld('heatcoolmodel',Ts);

% Design MPC controller
clear Q refs limits

refs.x=2;   % only state x(2) is weighted
Q.x=1;      % weight on state x(2)
Q.rho=Inf;  % hard constraints
%Q.norm=2;   % use quadratic costs
Q.norm=Inf; % use infinity norm
N=2;

limits.xmin=[25;-25];

C=hybcon(S,Q,N,limits,refs);
C.mipsolver='glpk';   % used for MILP
%C.mipsolver='cplex';  % used for MIQP
