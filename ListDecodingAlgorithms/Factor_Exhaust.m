function [ List,factor_list ] = Factor_Exhaust(Y,factors,m,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;%2^m -1 - 2*t;% k;
t = floor((n-k)/2);
l = ceil(sqrt(2*(n+1)/d)) - 1;
X = gf(2,m) .^ (0:n-1); %%X is the alpha list

x_limit     = m+l*d;
y_limit     = l;

List = gf(zeros(n,1),m);
factor_list = factors;
locations = find(double(factors.x));
count = size(locations,1);
limit = (n+1)^count;
factor_ex = gf(zeros(size(factors,1),1),m);
a = factor_ex;
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m);
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;
for j=1:n,
% 	for i=1:count,
% 		loc = locations(i);
%         div = (n+1)^(i-1);
% 		factor_ex(loc) = mod(floor(j/div),n+1);%gf(mod(j,n+1),m);
% 	end;
%     a = [a factor_ex];
    [valid msg] = Eval_Factor(x_mat,y_mat,factors*j,m,t,x_limit,y_limit);
    if valid,   
      List = [List msg];
      factor_list = [factor_list j*factors];
	end;
end;
% a';
%Remove initialisation value
List = List(:,2:size(List,2));
factor_list = factor_list(:,2:size(factor_list,2));
%Remove duplicate results
List = unique(List.x','rows')';
end
