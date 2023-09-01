function [split] = MPTtoolboxFeature(leaf,delta_star,parentConstr,x0True)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
prob=getProblem();
x = sdpvar(prob.nVar,1);
x0=sdpvar(prob.DIM_x0,1);
slack=sdpvar(1);
x0True=x0True';


delta_star=double(delta_star);
A=prob.A;
S=prob.S;
b=prob.b;

[res,~,flag]=intlinprog(prob.c',prob.iVar,prob.A,prob.b-prob.S*x0True,[],[],prob.lb,prob.ub);
constr=[
    slack<=0   
    A*x+S*x0-b<=slack;     
    x(prob.iVar)==delta_star';     
    abs(x0)<=prob.boxBoundX0];

[sol,diagnostics,aux,Valuefunction,OptimalSolution]  = solvemp(constr,slack,[],x0);
% figure
% plot(Valuefunction)
% title('MPT feat')
% [isin, inwhich] = isinside(sol{1}.Pn,x0True);
% if numel(inwhich)>1
%     inwhich=inwhich(1);
% end
inwhich=-1;
Pn=toPolyhedron(sol{1}.Pn);
maxV=1e9;
for i=1:numel(Pn)
    %Pn(i).A*x0True-Pn(i).b
    if(max(Pn(i).A*x0True-Pn(i).b)<=maxV)
        inwhich=i;
        maxV=max(Pn(i).A*x0True-Pn(i).b);
    end
    
end
split=[Pn(inwhich).A Pn(inwhich).b];

end