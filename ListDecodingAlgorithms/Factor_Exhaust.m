function [ List ] = Factor_Exhaust(Y,factors,m,k)
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
locations = find(double(factors.x));
count = size(locations,1);
limit = (n+1)^count;
factor_ex = gf(zeros(size(factors,1),1),m);
a = factor_ex;
for j=1:limit,
	for i=1:count,
		loc = locations(i);
        div = (n+1)^(i-1);
		factor_ex(loc) = mod(floor(j/div),n+1);%gf(mod(j,n+1),m);
	end;
    a = [a factor_ex];
    [valid msg] = Eval_Factor(X,Y,factor_ex,m,t,x_limit,y_limit);
    if valid,   
      List = [List msg];
	end;
end;
a'
%Remove initialisation value
List = List(:,2:size(List,2));
%Remove duplicate results
List = unique(List.x','rows')';
end
