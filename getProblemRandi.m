function [outputArg1] = getProblem()
%GETPROBLEM Summary of this function goes here
%   Detailed explanation goes here

persistent v
if isempty(v)
    nVar=10;
    nBin=6;
    DIM_x0=2;

    nConstr=8;
    boxBoundX0=1;



    c=randn(nVar,1);
    l_bound=-[ zeros(nBin,1) ; ones(nVar-nBin,1)] *boxBoundX0;
    u_bound=[ ones(nBin,1) ; ones(nVar-nBin,1) *boxBoundX0];
    A=rand(nConstr,nVar);
    b=rand(nConstr,1);
    S=rand(nConstr,DIM_x0);
    v=struct('c',c,'A',A,'b',b,'S',S,'lb',l_bound,'ub',u_bound,'iVar',1:nBin,'nVar',nVar, ...
        'DIM_x0',DIM_x0,'nConstr',nConstr,'boxBoundX0',boxBoundX0);

    disp('sss')
end

outputArg1=v;
end

