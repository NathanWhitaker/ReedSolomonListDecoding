function [valid,msg] = Eval_Factor(x_mat,Y,factor,m,t)
%EL Summary of this function goes here
%   This evaluates whether the factor that has been passed as a parameter 
%   by generating the associated message and comparing this to the actual 
%   recieved message and if these match for more than t places then it is
%   used
n = 2^m-1;
msg = x_mat * factor;%or_mat * y_mat';
count = sum((msg - Y) == 0);
if (count > (n-2*t)),
    valid = 1;
else
    valid = 0;
end;
end

