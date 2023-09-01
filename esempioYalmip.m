n = 3;
m = 2;

Q = randn(n,n);Q = Q*Q';
c = randn(n,1);
d = randn(m,1);
A = randn(15,n);
b = rand(15,1)*2*n;
E = randn(15,m);

H = randn(m,m);H = H*H';
e = randn(m,1);
f = randn(n,1);
F = randn(5,m);
h = rand(5,1)*2*m;
G = randn(5,n);

x = sdpvar(n,1);
z = sdpvar(m,1);
lambda = sdpvar(length(h),1);
slack = h + G*x - F*z;

KKT = [H*z + e + F'*lambda == 0,
                       F*z <=  h + G*x,
                    lambda >= 0];

for i = 1:length(h)
 KKT = [KKT, ((lambda(i)==0) | (slack(i) == 0))];
end  

KKT = [KKT, lambda <= 100, -100 <= [x;z] <= 100];

optimize([KKT, A*x <= b + E*z], 0.5*x'*Q*x + c'*x + d'*z);
value(x)
value(z)
value(lambda)
value(slack)

con_inner = F*z <=  h + G*x;
obj_inner = 0.5*z'*H*z+e'*z;
con_outer = A*x <= b + E*z;
obj_outer = 0.5*x'*Q*x + c'*x + d'*z;
solvebilevel(con_outer,obj_outer,con_inner,obj_inner,z)