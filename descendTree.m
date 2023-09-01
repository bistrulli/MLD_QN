function [stack] = descendTree(classTree,parentConstr)

stack=cell(numel(classTree.CutPredictor),1);
CutPredictorIndex=classTree.CutPredictorIndex;
prob=getProblem()
flag=true;
while flag
    flag=false;
    for i=1:numel(classTree.CutPredictor)
        thisDecisionVar=CutPredictorIndex(i);
        
        if classTree.IsBranchNode(i) && ~flag
            if thisDecisionVar==0
                continue;
            else
                thisThres=classTree.CutPoint(i);
                thisChildren=classTree.Children(i,:);
                left=zeros(1,prob.DIM_x0+1);
                left(1,end)=thisThres;
                left(1,thisDecisionVar)=1;
                right=zeros(1,prob.DIM_x0+1);
                right(1,thisDecisionVar)=-1;
                right(1,end)=-thisThres;                
                
                stack{i}
                if isempty(stack{i})
                    stack{thisChildren(1)}=left;
                    stack{thisChildren(2)}=right;
                else
                    stack{thisChildren(1)}=[stack{i};left]
                    stack{thisChildren(2)}=[stack{i};right]
                end
                CutPredictorIndex(i)=0;
                flag=true;
                break
            end
        end
    end
end

for i=1:numel(classTree.CutPredictor)
    stack{i}=struct('constr',stack{i},'class',classTree.NodeClass(i),'isLeaf',~classTree.IsBranchNode(i));
end

end

