function [ List ] = Q_Function_n_root( X,Y,m,x_limit,y_limit)
%Q_FUNCTION Summary of this function goes here
% http://www.louisiana.edu/Academic/Sciences/MATH/stage/puremath2011.pdf
% 
%   Detailed explanation goes here
n = 2^m-1;
limit = (y_limit+1)*(x_limit+1);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m); 
Comp_mat = gf(zeros(n,limit),m);

for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (0:y_limit);
end;

for i=1:n,
    Sel = x_mat(i,1:x_limit+1);
    Line = Sel;
    for j=1:y_limit,
        Line = [Line Sel*y_mat(i,j+1)];
    end;
    Comp_mat(i,:) = Line;
end;
List = gfnull(Comp_mat,'r');
end