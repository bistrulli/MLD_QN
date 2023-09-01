function [outputArg1] = getProblem()
%GETPROBLEM Summary of this function goes here
%   Detailed explanation goes here

persistent v
if isempty(v)
    %     Ts=1;
    %     milpsolver='glpk';
    %     S=mld('bm99',Ts,milpsolver);
    %
    %     clear Q refs limits
    %     refs.y=[]; % No output reference
    %     refs.x=[1 2];
    %     refs.u=[1];
    %     Q.x=10*eye(2);
    %     Q.xN=10*eye(2);
    %     Q.u=1;
    %     Q.rho=Inf; % Hard constraints
    %     Q.norm=Inf;
    %
    %     N=3;
    %     limits.umin=-1;
    %     limits.umax=1;
    S=mld('hybrid4');
    clear Q refs limits
    refs.y=[];
    refs.x=[1 2];
    refs.u=[1 2];
    Q.x=eye(2);
    Q.u=0*eye(2);
    Q.rho=Inf; % Hard constraints
    Q.norm=Inf;
    N=2;
    limits=[];
    boxBoundX0=5;
%     limits.xmin=[-boxBoundX0;-boxBoundX0];
%     limits.xmax=[boxBoundX0;boxBoundX0];

    C=hybcon(S,Q,N,limits,refs,'gurobi');
    CC=struct(C);
    DIM_x0=size(CC.Cx,2);%+size(CC.Cr.x,2)+size(CC.Cr.u,2);

    nVar=numel(CC.f);
    c=CC.f;
    l_bound=-inf(nVar,1);
    l_bound(CC.ivar)=0;
    u_bound=inf(nVar,1);
    u_bound(CC.ivar)=1;
    S=-[CC.Cx];% CC.Cr.x CC.Cr.u];
    A=CC.A;
    b=CC.b;
    nConstr=size(A,1);

    v=struct('c',c,'A',A,'b',b,'S',S,'lb',l_bound,'ub',u_bound,'iVar',CC.ivar,'nVar',nVar, ...
        'DIM_x0',DIM_x0,'nConstr',nConstr,'boxBoundX0',boxBoundX0);

    disp('sss')
end

outputArg1=v;
end

