function [ List ] = Q_Function_sudan( X,Y,m,k,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% Sudan Q(X,Y) definition
% Q(X,Y) = ?(j=0->l)?(k=0->(m+(l-j)d)[qkj*x^k*y^j]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;
limit = (y_limit+1)*(x_limit+1);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m); 
Mat_Mask = gf(ones(n,limit),m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Masking Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removes coefficients that are beyond the m+(l-j)*d limit seen in sudan
% definition of Q(X,Y)
for i=1:y_limit,
	bound = (x_limit+1)*(i+1);
    Mat_Mask(:,(bound + 1 - d*i):bound) = 0;
end;
% Create matrices containing increasing powers of X and Y values
 for i=1:n,
     x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
%     y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
 end;
X_t = X';
final_mat = x_mat;
for i=1:y_limit,
    sel = Y.^i;
    for j=1:x_limit
        sel = [sel X_t.^j.*(Y.^i)];
    end;
    final_mat = [final_mat sel];
end;
% create row from flattened coefficient matrix and stack for n input values
% for i=1:n,
%     X_Sel = x_mat(i,:);
%     Line = X_Sel;
%     for j=1:y_limit,%%inital part for y^0 taken care of line above
%         Line = [Line X_Sel.*y_mat(i,j+1)];
%     end;
%     Comp_mat(i,:) = Line;
% end;
% Comp_mat = x_mat;
% for i=1:y_limit+1,
%     for j=1:x_limit,
%         x_mat(:,j) = x_mat(:,j).*y_mat(:,i);
%     end;
%     Comp_mat = [Comp_mat x_mat];
% end;
Masked_Comp = final_mat.*Mat_Mask;
% Masked_Comp is the matrix of stacked lines that has been masked, to find 
% the polynomial that solves this the nullspace/kernel is found of the matrix
% Nullspace x of matrix A are the solutions to Ax=0
List = gfnull(Masked_Comp,'r',m);
end
