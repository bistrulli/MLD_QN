function [x0Value,vsValue] = checkEmpty(parentConstr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

prob=getProblem()
x0=sdpvar(prob.DIM_x0,1);




constr=[    
    abs(x0)<=prob.boxBoundX0;    
    ];

if ~isempty(parentConstr)
    for indx=1:size(parentConstr,1)
        if isstruct(parentConstr{indx})
            if parentConstr{indx}.nnz==1
                constr=[constr;
                    isoutside(parentConstr{indx}.split(:,1:end-1)*x0<=parentConstr{indx}.split(:,end))
                    ];
            else
                constr=[constr;
                    (parentConstr{indx}.split(:,1:end-1)*x0<=parentConstr{indx}.split(:,end))
                    ];
            end
        else
             constr=[constr;
                    (parentConstr{indx}(:,1:end-1)*x0<=parentConstr{indx}(:,end))
                    ];
        end
        
    end
end

vs=optimize(constr, 0);

x0Value=value(x0);
vsValue=vs.problem;
end