function [valid,msg] = Eval_Factor( X,Y,factor,p,m,t )
%EL Summary of this function goes here
%   Detailed explanation goes here
n = p^m-1;
n_root = floor(sqrt(n));

x_mat = gf(zeros(n,n_root+1),m);
factor_mat = gf(zeros(1,n_root+1),m);
msg = gf(zeros(n,1),m);
count = 0;

for i=1:n_root+1,
    factor_mat = factor(1:n_root+1);
end;
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:n_root);
end;

for i=1:n,
    msg(i) = x_mat(i,:) * factor_mat;
    if (msg(i) == Y(i)),
        count = count + 1;
    end;
end;
if (count > (n-t)),
    valid = 1;
else
    valid = 0;
end;
end

