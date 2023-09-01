Ts=.1;
milpsolver='glpk';
S=mld('bm99',Ts,milpsolver);

clear Q refs limits
refs.y=[]; % No output reference
refs.x=[1 2];
refs.u=[1];
Q.x=10*eye(2);
Q.xN=10*eye(2);
Q.u=1;
Q.rho=Inf; % Hard constraints
Q.norm=Inf;

N=7;
limits.umin=-10;
limits.umax=10;
limits.xmin=[-10;-10];
limits.xmax=[10;10];

C=hybcon(S,Q,N,limits,refs);
CC=struct(C)



