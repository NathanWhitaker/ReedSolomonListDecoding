function [inv_factors,x_mat,comb] = InvGen(m,t)
%INVGEN Summary of this function goes here
%   Detailed explanation goes here
n = 2^m-1;
k = n-2*t;
X = gf(2,m);
x = X.^(0:n-1);
x_mat = x.^0;
for i=1:k-1,
    x_mat = [x_mat; x.^i];
end;
x_mat = x_mat';
tStart = tic;
comb = nchoosek(1:n,k);
inv_factors = gf(zeros(k,k,size(comb,1)),m);
for i=1:size(comb,1),
    fact = [];
    for j=1:k,
        fact = [fact; x_mat(comb(i,j),:)];
    end;
    inv_factors(:,:,i) = inv(fact);
end;
end

