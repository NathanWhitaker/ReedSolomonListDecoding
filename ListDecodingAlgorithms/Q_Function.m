function [ List ] = Q_Function( X,Y,m )
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% 
%   Detailed explanation goes here
n = 2^m-1;
n_root = floor(sqrt(n));
limit = (n_root+1) ^2;
x_mat = gf(zeros(n,n_root+1),m);
y_mat = gf(zeros(n,n_root+1),m); 
Comp_mat = gf(zeros(n,limit),m);

for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:n_root);
    y_mat(i,:) = gf(Y(i),m) .^ (0:n_root);
end;

for i=1:n,
    Sel = x_mat(i,1:n_root+1);
    Line = Sel;
    for j=1:n_root,
        Line = [Line Sel*y_mat(i,j+1)];
    end;
    Comp_mat(i,:) = Line;
end;
List = gfnull(Comp_mat,'r');
end