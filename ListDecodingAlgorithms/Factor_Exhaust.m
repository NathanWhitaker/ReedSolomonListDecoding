function [ List, Factor_List ] = Factor_Exhaust(x_mat,y_mat,factors,m,t,x_limit,y_limit)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
List = gf(zeros(n,1),m);
Factor_List = gf(zeros((x_limit+1)*(y_limit+1),1),m);
for j=1:n,
    [valid, msg] = Eval_Factor(x_mat,y_mat,factors*j,m,t,x_limit,y_limit);
    if valid,   
      List = [List msg];
      Factor_List = [Factor_List factors*j];
    end;
end;
%Remove initialisation value
List = List(:,2:size(List,2));
Factor_List = Factor_List(:,2:size(Factor_List,2));
%Remove duplicate results
List = unique(List.x','rows')';
Factor_List = unique(Factor_List.x','rows')';
end
