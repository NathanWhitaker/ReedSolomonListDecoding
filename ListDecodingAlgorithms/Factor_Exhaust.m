function [ List ] = Factor_Exhaust(x_mat,y_mat,factors,m,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;%2^m -1 - 2*t;% k;
t = floor((n-k)/2);
l = ceil(sqrt(2*(n+1)/d)) - 1;
x_limit     = m+l*d;
y_limit     = l;
List = gf(zeros(n,1),m);
for j=1:n,
    [valid, msg] = Eval_Factor(x_mat,y_mat,factors*j,m,t,x_limit,y_limit);
    if valid,   
      List = [List msg];
    end;
end;
%Remove initialisation value
List = List(:,2:size(List,2));
%Remove duplicate results
List = unique(List.x','rows')';
end
