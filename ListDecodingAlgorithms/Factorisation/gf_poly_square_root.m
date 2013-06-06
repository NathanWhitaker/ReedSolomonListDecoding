function [ factors ] = gf_poly_square_root( poly,m )
%% Recursively un-squares polynomials, and when normalises to unit leading coefficient
coeff_new = gf_poly_coeff_root(poly,m);
factors = gf(zeros(size(poly,1),1),m);
for(i=0:floor(size(poly,1)/2)-1),
    factors(i+1) = coeff_new(2*i+1);
end;

for i=1:size(factors,2),
    if (gf_poly_square(factors(:,1),m)),
        factors = [factors gf_poly_square_root(factors,m)];
    end;
end;

for i=1:size(factors,2),
    factors(:,i) = factors(:,i)/gf_poly_lc(factors(:,i),m); 
end;

end

    