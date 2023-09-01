clear

Ts=1;
milpsolver='glpk';
S=mld('QNMLD',Ts,milpsolver);

clear Q refs limits
refs.y=[]; % No output reference
refs.x=[1 2];
refs.u=[1 2];
Q.x=10*eye(2);
Q.xN=10*eye(2);
Q.u=eye(2);
Q.rho=Inf; % Hard constraints
Q.norm=Inf;

N=10;
limits.umin=[ 0;0];
limits.umax=[ 20;20];
limits.xmin=[ 0;0];
limits.xmax=[100;100];

C=hybcon(S,Q,N,limits,refs);
Tstop=100;
x0=[10;0];
r.x=(1+cos(1:100))'/2.*[7,3];
r.u=ones(100,1).*[0,0];

[XX,UU,DD,ZZ,TT,YY]=sim(C,S,r,x0,Tstop);
subplot(211);
plot(TT,YY,TT,r.x);
grid
subplot(212);
plot(TT,UU);
grid
