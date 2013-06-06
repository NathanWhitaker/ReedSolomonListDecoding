function [ poly_is_square ] = gf_poly_square( poly,m )
%% Check whether a polynomial is square, is all odd powers are zero
%% then it is square
poly_coeff = min(poly.x,1);
coeff_sum = 0;
for i=0:floor(size(poly,1)/2)-1,
	%odd powers at even locations
    coeff_sum = coeff_sum + poly_coeff(2*i+2); 
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
