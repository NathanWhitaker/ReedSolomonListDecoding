function [ List ] = Sudan(Y,m,n,k)
%SUDAN Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% System Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
X = gf(2,m) .^ (0:n-1); %%X is the alpha list
t = floor((n-k)/2);
List_count = 0;
List = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Q(X,Y) Relationship between X and Y %%%%%%%%%
tStart = tic;
polynomials = Q_Function(X,Y,m);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Factor Polynomials %%%%%%%%%%%%%%%%%%%%%%%%%%
if size(polynomials,2) >= 1,
    factors = Factorise_gf(X,Y,2,m,polynomials(:,1));
end;
for i=2:size(polynomials,2),
    factors = [factors Factorise_gf(X,Y,2,m,polynomials(:,i))];
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Evaluate Polynomials %%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(factors,2),
    [valid msg] = Eval_Factor(X,Y,factors(:,i),2,m,t);
    if valid,   
        List_count = List_count + 1;
        if List_count == 1,
            List = msg;
        else
            List = [List msg];
        end;
    end      
end;
List
fprintf('List Size is : %d\r',List_count); 
fprintf('Total Time : %d s\r',toc(tStart));