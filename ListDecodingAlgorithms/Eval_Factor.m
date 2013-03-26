function [valid,msg] = Eval_Factor(X,Y,factor,m,t,x_limit,y_limit)
%EL Summary of this function goes here
%   This evaluates whether the factor that has been passed as a parameter 
%   by generating the associated message and comparing this to the actual 
%   recieved message and if these match for more than t places then it is
%   used
n = 2^m-1;
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m);
res = gf(zeros(n,1),m);
factor_mat = gf(zeros(x_limit+1,y_limit+1),m);
factor = 2*factor;

for i=1:y_limit+1,
    factor_mat(:,i) = factor((i-1)*(x_limit+1)+1:i*(x_limit+1));
end;

for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;

result = x_mat * factor_mat * y_mat';
%fprintf('Result :')
%result
%res
for i=1:n,
	res(:,1) = res(:,1) + result(:,1);
end;
msg = res;%result(1,:)';
%msg
%Y
count = sum((msg - Y) == 0);

if (count > (t)),
    valid = 1;
		factor_mat
else
    valid = 0;
end;
end

