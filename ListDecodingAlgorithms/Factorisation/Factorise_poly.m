function [ factors ] = Factorise_poly( poly,m )
%FACTORISE_POLY Summary of this function goes here
%   Detailed explanation goes here

factors = [];
all_factors = poly;
while(~isequal(factors,all_factors)),
    factors = all_factors;
    all_factors = [];
    for i=1:size(factors,2),
        if(gf_poly_square(factors(:,i),m)),
            factors_new = gf_poly_square_root(factors(:,i),m);
        else
            factors_new = SFF(factors(:,i),m);
        end;
        all_factors = [all_factors factors_new];
    end;
end;
end

