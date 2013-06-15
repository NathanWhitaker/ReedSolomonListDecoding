function [ unique_factors ] = MyAlgorithm(m,t,data,inv_factors,comb)
%MYALGORITHM Summary of this function goes here
%   Detailed explanation goes here
tStart = tic;
n = 2^m-1;
k = n-2*t;
comb = nchoosek(1:n,k);
factors = [];
for i=1:size(comb,1),
    Data_Sel = [];
    for j=1:k,
        Data_Sel = [Data_Sel; data(comb(i,j))];
    end;
    factors = [factors inv_factors(:,:,i)*Data_Sel];
end;
factors = factors.x;
unique_factors = unique(factors','rows')';
fprintf('Total Time : %d s\r\n',toc(tStart));
end

