function [ List_Full ] = Q_Function_sudan( x_mat,Y,m,k,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% Sudan Q(X,Y) definition
% Q(X,Y) = ?(j=0->l)?(k=0->(m+(l-j)d)[qkj*x^k*y^j]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 2^m-1;
d = k;
limit = (y_limit+1)*(x_limit+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Masking Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create matrices containing increasing powers of X and Y values
final_mat = x_mat;
sub_size = x_limit+1;
X = x_mat(:,2);
for i=1:y_limit,
    sel = Y.^i;
    for j=1:x_limit-1-(k-1)*i,
        sel = [sel X.^j.*(Y.^i)];
    end;
    % Removes coefficients that are beyond the m+(l-j)*d limit seen in sudan
    % definition of Q(X,Y)
    %sel = sel(:,1:max(x_limit+1-i*d,0));
    sub_size = [sub_size; max(x_limit-1-i*(k-1),0)]; 
    final_mat = [final_mat sel];
end;
cumulative_size = cumsum(sub_size);
% Masked_Comp is the matrix of stacked lines that has been masked, to find 
% the polynomial that solves this the nullspace/kernel is found of the matrix
% Nullspace x of matrix A are the solutions to Ax=0
fprintf('Rank : %d, %d\r\n',rank(final_mat),rank(final_mat'));
List = gfnull(final_mat(1:rank(final_mat),:),'r',m);
List_Full = gf(zeros(limit,size(List,2)),m);
List_Full(1:x_limit+1,:) = List(1:x_limit+1,:);
for i=1:y_limit,
    start = (x_limit+1)*i+1;
    List_Full(start:start+sub_size(i+1)-1,:) = List(cumulative_size(i)+1:cumulative_size(i+1),:);
end;
% ones = gf(zeros(limit,1),m);
% ones(1) = 1;
% List_Full = [ones List_Full];
end
