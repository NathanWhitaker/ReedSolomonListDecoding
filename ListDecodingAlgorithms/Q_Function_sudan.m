function [ List ] = Q_Function_sudan( x_mat,Y,m,k,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% Sudan Q(X,Y) definition
% Q(X,Y) = ?(j=0->l)?(k=0->(m+(l-j)d)[qkj*x^k*y^j]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;
limit = (y_limit+1)*(x_limit+1);
Mat_Mask = gf(ones(n,limit),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Masking Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removes coefficients that are beyond the m+(l-j)*d limit seen in sudan
% definition of Q(X,Y)
for i=1:y_limit,
	bound = (x_limit+1)*(i+1);
    Mat_Mask(:,(bound + 1 - d*i):bound) = 0;
end;
% Create matrices containing increasing powers of X and Y values
final_mat = x_mat;
for i=1:y_limit,
    sel = Y.^i;
    for j=1:x_limit
        sel = [sel x_mat(:,j).*(Y.^i)];
    end;
    final_mat = [final_mat sel];
end;
Masked_Comp = final_mat.*Mat_Mask;
% Masked_Comp is the matrix of stacked lines that has been masked, to find 
% the polynomial that solves this the nullspace/kernel is found of the matrix
% Nullspace x of matrix A are the solutions to Ax=0
List = gfnull(Masked_Comp,'r',m);
end
