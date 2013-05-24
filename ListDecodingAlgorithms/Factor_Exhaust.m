function [ List ] = Factor_Exhaust(x_mat,y_mat,factors,m,t,x_limit,y_limit)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
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
