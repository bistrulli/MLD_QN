clear all
rng('default') 
options = optimoptions(@intlinprog,'OutputFcn',@savemilpsolutions);
rng(219)
%rng(130)
dimDataset=200
prb=getProblem();





datasetX=zeros(dimDataset,prb.DIM_x0);
datasetY=zeros(dimDataset,numel(prb.iVar));
for i=1:dimDataset
    x0=(rand(prb.DIM_x0,1)*2-1)*prb.boxBoundX0;
    datasetX(i,:)=x0;
    [res,~,flag]=intlinprog(prb.c',prb.iVar,prb.A,prb.b-prb.S*x0,[],[],prb.lb,prb.ub);
    %MILPSOL(f,A,b,ivar)
%    [X,FLAG] =milpsol(prb.c',prb.A,prb.b-prb.S*x0,prb.iVar,8);
    assert(flag==1)
    datasetY(i,:)=res(prb.iVar);
    i
end
classifier=recursiveSynthesis(datasetX,datasetY,{},1,false(200,1));