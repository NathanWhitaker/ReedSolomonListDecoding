function [ Comp_mat ] = Q_Function( X,Y,l,d,m )
%Q_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
n = 2^m-1;
x_limit = m+l*d;
y_limit = l;
limit = ((d/2)*l^2 + (m+d/2)*l + m);
x_mat = gf(zeros(n,x_limit+1),m);
y_mat = gf(zeros(n,y_limit+1),m); 
Comp_mat = gf(zeros(n,limit),m);
for i=1:n,
    x_mat(i,:) = gf(X(i),m) .^ (0:x_limit);
    y_mat(i,:) = gf(Y(i),m) .^ (1:y_limit);
end;
for j=1:n,
    Line = x_mat(j,1:x_limit);
    for i=1:l,
        a = x_mat(j,1:x_limit-d*i);
        for k=1:size(a,2),
            a(k) = a(k) * y_mat(j,i+1);
        end;
        Line = [Line a];
%          Line = [Line (x_mat(j,1:x_limit-d*i) .* y_mat(j,i))];
    end;
    Comp_mat(j,:) = Line;
end;
end
