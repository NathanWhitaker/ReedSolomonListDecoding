function [ poly_coeff_root ] = gf_poly_coeff_root( poly,m )
%GF_POLY_COEFF_ROOT Summary of this function goes here
%   Detailed explanation goes here
coeffs = gf(0:2^m-1,m);
coeffs_square = coeffs.^2;
poly_coeff_root = gf(zeros(size(poly,1),1),m);
for i=1:size(poly,1),
    loc = find(coeffs_square == poly(i));
    poly_coeff_root(i) = coeffs(loc);
end;

end

