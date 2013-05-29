function [ poly_leading_coeff ] = gf_poly_lc( poly,m )
%GF_POLY_LC Summary of this function goes here
%   Detailed explanation goes here
poly_leading_coeff = poly(gf_poly_deg(poly,m)+1);
end

