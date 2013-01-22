function [ Q_Sum ] = Q_Weighted_Sum(X,Y,c_kj,m,l,d)
%Q_RELATIONSHI Summary of this function goes here
%   Detailed explanation goes here
k_limit = m+l*d;
Q = gf(zeros(l+1,k_limit+1),m);
x_mat = X .^ [0:k_limit];
y_mat = Y .^ [0:l];
vert_ones = gf(ones(1,k_limit+1),m);
horz_ones = gf(ones(l+1,1),m);
for j=0:l,
    Q(j+1,:) =  (x_mat .* y_mat(j+1)) .* c_kj(:,j+1)';
end;
Q_Sum = horz_ones' * (Q * vert_ones');
end
