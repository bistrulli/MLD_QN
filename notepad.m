clear all
clc

n = 7;
m = 20;

x = sdpvar(n,1);
x0=sdpvar(n,1);
slack=sdpvar(1)



A=randn(m,n)
B=randn(m,n)
b=randn(m,1)


constr=[A*x+B*x0+b<=slack; abs(x)<=10;abs(x0)<=1]
%optimize(constr, slack);
innerKKT=kkt(constr,slack,x0);
vs=optimize([innerKKT; abs(x0)<=1; slack>=0.01], 0);
s=optimize([A*x+B*value(x0)+b<=0; abs(x)<=10;], 0);

% 
% solvebilevel([abs(x0)<=1; slack>=0.1],-slack,constr,slack,x)
% 
% s2=optimize([A*x+B*value(x0)+b<=0; abs(x)<=10;], 0);