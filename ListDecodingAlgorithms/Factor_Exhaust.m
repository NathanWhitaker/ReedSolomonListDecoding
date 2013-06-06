function [ List, Factor_List ] = Factor_Exhaust(x_mat,Y,factor,m,t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
factor_mat = [diag(0:n);zeros(size(factor,1)-n-1,n+1)];
Y_Concat = repmat(Y,[1 n+1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Factor Evaluation %%%%%%%%%%%%%%%%%%%%%%%%%%%
factors = repmat(factor,[1 size(factor,1)])*factor_mat;
Factor_Mult = x_mat*factors;
Intersection = find(sum((Factor_Mult + Y_Concat)==0)>=t);
List = Factor_Mult(:,Intersection);
Factor_List = factors(:,Intersection);
 end