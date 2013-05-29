function [ List_Full ] = Q_Function_sudan(x_mat,y_mat,m,d,k,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% Sudan Q(X,Y) definition
% Q(X,Y) = ?(j=0->l)?(k=0->(m+(l-j)d)[qkj*x^k*y^j]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
limit = (y_limit+1)*(x_limit+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Masking Matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create matrices containing increasing powers of X and Y values
X = x_mat(:,2);
Y = y_mat(:,2);
final_mat = [];
sub_size = [];
for j=0:y_limit,
    sel = [];
    Y_pow = y_mat(:,j+1);%Y.^j;
    x_limit_j = x_limit-(k-1)*j;
    for k=0:x_limit_j,
        sel = [sel x_mat(:,k+1).*Y_pow];%X.^k
    end;
    % Removes coefficients that are beyond the m+(l-j)*d limit seen in sudan
    % definition of Q(X,Y)
    %sel = sel(:,1:max(x_limit+1-i*d,0));
    sub_size = [sub_size; max(x_limit_j,0)]; 
    final_mat = [final_mat sel];
end;
cumulative_size = cumsum(sub_size);
% Masked_Comp is the matrix of stacked lines that has been masked, to find 
% the polynomial that solves this the nullspace/kernel is found of the matrix
% Nullspace x of matrix A are the solutions to Ax=0
fprintf('Rank : %d, %d\r\n',rank(final_mat),rank(final_mat'));
%try
    List = gfnull(final_mat(1:rank(final_mat)-2,:),'r',m);
%catch
%    fprintf('Divide Zero');
%    List = gf(zeros(limit,1),m);
%end;
List_Full = gf(zeros(limit,size(List,2)),m);
List_Full(1:x_limit+1,:) = List(1:x_limit+1,:);
for i=1:y_limit,
    start = (x_limit+1)*i+1;
    List_Full(start:start+sub_size(i+1)-1,:) = List(cumulative_size(i)+1:cumulative_size(i+1),:);
end;
ones = gf(zeros(limit,1),m);
ones(1) = 1;
List_Full = [ones List_Full];
end
