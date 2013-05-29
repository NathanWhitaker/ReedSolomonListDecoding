function [ poly_deg ] = gf_poly_deg( poly,m )
%GF_POLY_DEG Summary of this function goes here
%   Detailed explanation goes here
poly = gf(poly,m);
poly_coeff = min(poly.x,1);
locations = find(poly_coeff==1);
if(~isempty(locations)),
   poly_deg = locations(size(locations,1))-1; %%Degree 1 less then location
else
    poly_deg = 0;
end;
end

