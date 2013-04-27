function [valid,msg] = Eval_Factor(x_mat,y_mat,factor,m,t,x_limit,y_limit)
%EL Summary of this function goes here
%   This evaluates whether the factor that has been passed as a parameter 
%   by generating the associated message and comparing this to the actual 
%   recieved message and if these match for more than t places then it is
%   used
n = 2^m-1;
% factor_mat = gf(zeros(x_limit+1,y_limit+1),m);
% factor = 2*factor;
% for i=1:y_limit+1,
%     factor_mat(:,i) = factor((i-1)*(x_limit+1)+1:i*(x_limit+1));
% end;
fact = factor(1:x_limit+1);
result = x_mat * fact; %factor_mat * y_mat';
msg = result;%(1,:)';
count = sum((msg - y_mat(:,2)) == 0);
if (count > (n-2*t)),
    valid = 1;
else
    valid = 0;
end;
end

