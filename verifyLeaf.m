function [x0Value,vsValue] = verifyLeaf(leaf,~,parentConstr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
prb=getProblem();
x = sdpvar(prb.nVar,1);
x0=sdpvar(prb.DIM_x0,1);
slack=sdpvar(1);



A=prb.A;
S=prb.S;
b=prb.b;
seed=rand(prb.DIM_x0,1);

constr=[A*x+S*x0-b<=slack;
    x(prb.iVar)==str2num(leaf.class)';
    ];

innerKKT=kkt(constr,slack,x0);
outerConstr=[innerKKT; ...    
    abs(x0)<=prb.boxBoundX0; ...    
    slack>=0.000];


exclusionConstr=[];
if ~isempty(leaf.constr)
    exclusionConstr=[exclusionConstr;
        leaf.constr(:,1:end-1)*x0<=leaf.constr(:,end);
        ];
end

if ~isempty(parentConstr)
    for indx=1:size(parentConstr,1)
        if isstruct(parentConstr{indx})
            if parentConstr{indx}.nnz==1
                exclusionConstr=[exclusionConstr;
                    isoutside(parentConstr{indx}.split(:,1:end-1)*x0-parentConstr{indx}.split(:,end)<=1e-3)
                    ];
            else
                exclusionConstr=[exclusionConstr;
                    (parentConstr{indx}.split(:,1:end-1)*x0<=parentConstr{indx}.split(:,end))
                    ];
            end
        else
            exclusionConstr=[exclusionConstr;
                (parentConstr{indx}(:,1:end-1)*x0<=parentConstr{indx}(:,end))
                ];
        end
    end
end
if size(exclusionConstr,1)>3
    figure ; plot([abs(x0)<=5; exclusionConstr])
end
outerConstr=[outerConstr;exclusionConstr];
%vs=optimize(outerConstr, norm(seed-x0,1)+norm(slack-1,1));
vs=optimize(outerConstr, 0);

x0Value=value(x0);
vsValue=vs.problem;
end