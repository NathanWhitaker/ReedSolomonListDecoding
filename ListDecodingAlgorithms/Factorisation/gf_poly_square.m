function [ poly_is_square ] = gf_poly_square( poly,m )
%GF_POLY_SQUARE Summary of this function goes here
%   Detailed explanation goes here
poly_coeff = min(poly.x,1);
coeff_sum = 0;
for i=0:floor(size(poly,1)/2)-1,
    coeff_sum = coeff_sum + poly_coeff(2*i+2); %locations of odd powers at even locations
end
if (coeff_sum > 0),
    poly_is_square = 0;
else
    if (gf_poly_deg(poly,m) > 0),
        poly_is_square = 1;
    else
        poly_is_square = 0;
    end;
end;
end
