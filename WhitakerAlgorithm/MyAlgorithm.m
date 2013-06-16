function [ factor,List ] = MyAlgorithm(m,t,data,inv_factors,comb,x_mat)
%MYALGORITHM Summary of this function goes here
%   Detailed explanation goes here
tStart = tic;
n = 2^m-1;
k = n-2*t;
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
List = [];
min_distance = n-t;
for i=1:size(unique_factors,2),
    fact_list = x_mat * unique_factors(:,i);
    if (unique_factors(3,i) ==0),
        if(sum((fact_list-data)~=0) < min_distance),
            List = fact_list;
            factor = unique_factors(:,i);
            min_distance = sum((fact_list-data)~=0);
        end;
    end;
end;
fprintf('Total Time : %d s\r\n',toc(tStart));
end

