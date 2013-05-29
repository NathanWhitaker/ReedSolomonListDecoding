function [ List, Factor_List ] = Factor_Exhaust(x_mat,Y,factor,m,t)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
List = [];
Factor_List = [];
for j=1:n,
    [valid, msg] = Eval_Factor(x_mat,Y,j*factor,m,t);
    if valid,   
      List = [List msg];
      Factor_List = [Factor_List factor*j];
    end;
end;
end
