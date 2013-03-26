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
for j=1:n,
  [valid msg] = Eval_Factor(X,Y,j*factors,m,t,x_limit,y_limit);
  if valid,   
      List = [List msg];
 	end;
end;
msg
%Remove initialisation value
List = List(:,2:size(List,2));
%Remove duplicate results
List = unique(List.x','rows')';
end
