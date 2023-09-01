function [classTree] = recursiveSynthesis(datasetX,datasetY,parentConstr,level,counterExampleMask)
prb=getProblem();
datasetY=int32(datasetY);

if numel(datasetY)==0
    classTree=0;
    [x0,vs]=checkEmpty(parentConstr);
    if vs~=0
        return
    else
        datasetX=[datasetX; x0'];
        [res,~,flag]=intlinprog(prb.c',prb.iVar,prb.A,prb.b-prb.S*x0,[],[],prb.lb,prb.ub);
        assert(flag==1)
        datasetY=[datasetY; res(prb.iVar)'];
        datasetY=int32(datasetY);
    end
end

stringMatrix = arrayfun(@(row) strtrim(num2str(datasetY(row, :))), 1:size(datasetY, 1), 'UniformOutput', false);
stringMatrix=categorical(stringMatrix);
classTree=fitctree(datasetX,stringMatrix,'MinLeafSize',3,'Weights',counterExampleMask*100+1);
stack=descendTree(classTree);

allfeasible=true;

%% check accuracy on previously found counter-example
counterExampleMask=counterExampleMask>0;
predictedY=predict(classTree,datasetX);
if ~all(counterExampleMask<0.5) && ~all(str2double(string(predictedY(counterExampleMask,:)).split())==datasetY(counterExampleMask,:),'all')
    firstCounterExampleX=datasetX(counterExampleMask,:);
    firstCounterExampleY=datasetY(counterExampleMask,:);
    
    split=MPTtoolboxFeature([],firstCounterExampleY(1,:),parentConstr,firstCounterExampleX(1,:));
    bin=all(split(:,1:end-1)*datasetX'-split(:,end)<=1e-3)';
    assert(sum(bin)>0);
    thisDatasetX=datasetX(~bin,:);
    counterExampleMask=counterExampleMask(~bin,:);
    thisDatasetY=datasetY(~bin,:);
    
    tmpB=recursiveSynthesis(thisDatasetX,thisDatasetY,[parentConstr; struct('split',split,'nnz',1)],level+1,counterExampleMask);
    classTree={struct('split',split,'nnz',0,'sol',firstCounterExampleY,'else',tmpB)};
    return;
end

%%
counterExampleMask=zeros(size(datasetY,1),1);
for i=1:numel(stack)
    if stack{i}.isLeaf
        [x0,flag]=verifyLeaf(stack{i},prb,parentConstr);
        stack{i}.feasible=flag;
        if stack{i}.feasible
            disp("feasible split")

        else
            allfeasible=false;
            datasetX=[datasetX; x0'];
            counterExampleMask=[counterExampleMask ;1];
            [res,~,flag]=intlinprog(prb.c',prb.iVar,prb.A,prb.b-prb.S*x0,[],[],prb.lb,prb.ub);
            assert(flag==1)
            datasetY=[datasetY; res(prb.iVar)'];


        end
    end
end
datasetY=int32(datasetY);


%predictedY=predict(classTree,datasetX)
%%
% if numel(stack)==1 && ~allfeasible
%     split=MPTtoolboxFeature(stack{i},res(prb.iVar)',parentConstr,x0);
%     bin=all(split(:,1:end-1)*datasetX'-split(:,end)<=1e-6)';
%     thisDatasetX=datasetX(~bin,:);
%     thisDatasetY=datasetY(~bin,:);
%     tmpB=recursiveSynthesis(thisDatasetX,thisDatasetY,[parentConstr; struct('split',split,'nnz',1)],level+1,0);
%     classTree={struct('split',split,'nnz',0,'sol',res(prb.iVar)','else',tmpB)};
%
% else

bin=zeros(size(datasetX,1),1);
for idx_x=1:size(datasetX,1)
    flag=false;
    x0=datasetX(idx_x,:)';
    for i=1:numel(stack)
        if stack{i}.isLeaf
            leaf=stack{i};
            if(isempty(leaf.constr) ||  all(leaf.constr(:,1:end-1)*x0<=leaf.constr(:,end)))
                %assert(string(predictedY(idx_x))==string(leaf.class))
                flag=true;
                bin(idx_x,1)=i;
                break;
            end
        end
    end
    assert(flag);
end
%%
datasetY=int32(datasetY);
for idx_leaf=1:numel(stack)
    if stack{idx_leaf}.isLeaf && ~stack{idx_leaf}.feasible
        thisDatasetX=datasetX(bin==idx_leaf,:);
        thisMask=counterExampleMask(bin==idx_leaf,:);
        thisDatasetY=datasetY(bin==idx_leaf,:);
        tmp=recursiveSynthesis(thisDatasetX,thisDatasetY,[parentConstr; stack{idx_leaf}.constr],level+1,thisMask);
        classTree={classTree;struct('split',idx_leaf,'nextNode',tmp)};
    end
end
% end
end