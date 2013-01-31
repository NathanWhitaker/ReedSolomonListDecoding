function [ List ] = Q_Function_sudan( X,Y,m,k,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% Sudan Q(X,Y) definition
% Q(X,Y) = ?(j=0->l)?(k=0->(m+(l-j)d)[qkj*x^k*y^j]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = 2^m - k;
limit = (y_limit+1)*(x_limit+1);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m); 
Comp_mat = gf(zeros(n,limit),m);
Mat_Mask = gf(ones(n,limit),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Masking Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removes coefficients that are beyond the m+(l-j)*d limit seen in sudan
% definition of Q(X,Y)
for i=1:y_limit,
     Mat_Mask(:,(x_limit+1)*2 - d*i + 1:(x_limit+1)*2) = 0;
end;
% Create matrices containing increasing powers of X and Y values
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;
% create row from flattened coefficient matrix and stack for n input values
% x_mat(i) = (1 X(i) X(i)^2 .. X(i)^(m+ld));
% line = cat(x_mat(i),x_mat(i)*Y(i),...,x_mat(i)^(m+ld)*Y(i)^l);
for i=1:n,
    Sel = x_mat(i,1:x_limit+1);
    Line = Sel;
    for j=1:y_limit,
        Line = [Line Sel*y_mat(i,j+1)];
    end;
    Comp_mat(i,:) = Line;
end;
Masked_Comp = Comp_mat.*Mat_Mask;
% Masked_Comp is the matrix of stacked lines that has been masked, to find 
% the polynomial that solves this the nullspace/kernel is found of the matrix
% Nullspace x of matrix A are the solutions to Ax=0
List = gfnull(Masked_Comp,'r');
end